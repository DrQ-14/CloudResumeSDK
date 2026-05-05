//Worker1
function withCors(response: Response) {
  // ✅ SAFE: create a fresh Headers object
  const headers = new Headers(response.headers);

  headers.set(
    "Access-Control-Allow-Origin",
    "https://www.tanager-solutions.com",
  );

  headers.set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");

  headers.set("Access-Control-Allow-Headers", "Content-Type");

  // ✅ SAFE: reuse original response directly (no body manipulation)
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

    const allowed = ["/api/ResumeCounter"];

    // HANDLE PREFLIGHT FIRST
    if (request.method === "OPTIONS") {
      return withCors(new Response(null, { status: 204 }));
    }

    // ROUTE LOCK
    if (!allowed.includes(pathname)) {
      return withCors(new Response("Not Found", { status: 404 }));
    }

    const cache = caches.default;
    const cacheKey = new Request(url.toString(), request);

    let response = await cache.match(cacheKey);

    if (response) {
      return withCors(response);
    }

    const targetUrl = env.AZURE_FUNCTION_URL + pathname + url.search;

    const forwardedRequest = new Request(targetUrl, request);

    forwardedRequest.headers.set("x-origin-secret", env.ORIGIN_SECRET);

    try {
      response = await fetch(forwardedRequest);
    } catch (err) {
      return withCors(new Response("Azure unreachable", { status: 502 }));
    }

    // ALWAYS wrap even errors from Azure
    if (!response) {
      return withCors(new Response("No response from origin", { status: 502 }));
    }

    if (!response.ok) {
      const text = await response.text();

      return withCors(new Response(text, { status: response.status }));
    }

    const finalResponse = withCors(response);

    ctx.waitUntil(cache.put(cacheKey, finalResponse.clone()));

    return finalResponse;
  },
};
