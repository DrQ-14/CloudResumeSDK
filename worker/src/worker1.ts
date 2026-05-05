//Worker1
function withCors(response: Response) {
  const headers = new Headers(response.headers);

  headers.set(
    "Access-Control-Allow-Origin",
    "https://www.tanager-solutions.com",
  );

  headers.set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");

  headers.set("Access-Control-Allow-Headers", "Content-Type");

  return new Response(response.body, {
    status: response.status,
    statusText: response.statusText,
    headers,
  });
}

export default {
  async fetch(request: Request, env: any, ctx: any) {
    const url = new URL(request.url);
    const pathname = url.pathname;
    console.log("WORKER HIT:", {
      pathname,
      url: request.url,
      method: request.method,
    });

    // 1. HEALTH CHECK ROUTE
    if (pathname === "/") {
      // Why: prevents confusing 404s and gives you a simple uptime check
      return new Response("OK", { status: 200 });
    }

    // 2. MAIN API ROUTE (PRODUCTION DESIGN)
    if (pathname === "/api/ResumeCounter") {
      // Why: explicit routing is safer than allowlists
      // Why: makes API behavior predictable and scalable

      const cache = caches.default;
      const cacheKey = new Request(url.toString(), request);

      let response = await cache.match(cacheKey);

      // Why: avoids repeated Azure calls (performance + cost reduction)
      if (response) {
        return withCors(response);
      }

      const targetUrl = env.AZURE_FUNCTION_URL + pathname + url.search;

      const forwardedRequest = new Request(targetUrl, {
        method: request.method,
        headers: request.headers,
        body: request.body,
      });

      // Why: passes secret securely to backend for authentication
      forwardedRequest.headers.set("x-origin-secret", env.ORIGIN_SECRET);

      try {
        response = await fetch(forwardedRequest);
      } catch (err) {
        // Why: prevents hard failure if Azure is temporarily unreachable
        return withCors(new Response("Azure unreachable", { status: 502 }));
      }

      if (!response || !response.ok) {
        // Why: preserves Azure error response instead of hiding it
        const text = await response.text();
        return withCors(
          new Response(text, { status: response?.status || 502 }),
        );
      }

      const finalResponse = withCors(response);

      // Why: stores response at Cloudflare edge for faster future requests
      ctx.waitUntil(cache.put(cacheKey, finalResponse.clone()));

      return finalResponse;
    }
  },
};
