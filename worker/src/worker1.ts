//Worker1
function withCors(response: Response, extraHeaders: Headers = new Headers()) {
  const headers = new Headers(response.headers);

  headers.set(
    "Access-Control-Allow-Origin",
    "https://www.tanager-solutions.com",
  );

  headers.set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");

  headers.set("Access-Control-Allow-Headers", "Content-Type");

  // Why: allows us to attach Set-Cookie when needed
  for (const [key, value] of extraHeaders.entries()) {
    headers.set(key, value);
  }

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

      const cookieHeader = request.headers.get("Cookie") || "";

      // Try to extract existing visitorId from cookies
      let visitorId = cookieHeader
        .split(";")
        .map((c) => c.trim())
        .find((c) => c.startsWith("visitorId="))
        ?.split("=")[1];

      let isNewVisitor = false;

      // If no cookie exists → this is a new visitor
      if (!visitorId) {
        visitorId = crypto.randomUUID(); // Why: generate unique ID per user
        isNewVisitor = true;
      }

      // STEP B: CHECK KV (HAVE WE SEEN THIS USER?)
      const existing = await env.VISITORS_KV.get(visitorId);

      // If not found in KV → first time we’ve seen this visitor
      if (!existing) {
        isNewVisitor = true;

        // Store visitor in KV with expiration (e.g. 1 day)
        await env.VISITORS_KV.put(visitorId, "1", {
          expirationTtl: 86400, // Why: prevents permanent storage + allows recount later
        });
      }

      // STEP C: DECIDE WHETHER TO INCREMENT
      let response;

      if (isNewVisitor) {
        // Why: only call Azure when we need to increment

        const targetUrl = env.AZURE_FUNCTION_URL + pathname + url.search;

        const forwardedRequest = new Request(targetUrl, {
          method: request.method,
          headers: request.headers,
          body: request.body,
        });

        forwardedRequest.headers.set("x-origin-secret", env.ORIGIN_SECRET);

        try {
          response = await fetch(forwardedRequest);
        } catch {
          return withCors(new Response("Azure unreachable", { status: 502 }));
        }
      } else {
        // Why: skip increment for repeat visitor
        // You can either:
        // - call a "get count" endpoint
        // - OR return a cached/static response

        const targetUrl = env.AZURE_FUNCTION_URL + "/api/GetCounter";

        response = await fetch(targetUrl);
      }

      if (!response || !response.ok) {
        const text = await response.text();
        return withCors(
          new Response(text, { status: response?.status || 502 }),
        );
      }

      // STEP D: SET COOKIE (IF NEW USER)
      const extraHeaders = new Headers();

      if (isNewVisitor) {
        extraHeaders.set(
          "Set-Cookie",
          `visitorId=${visitorId}; Path=/; Max-Age=31536000; HttpOnly; Secure`,
        );
        // Why:
        // - persists identity across reloads
        // - prevents duplicate counting
      }

      return withCors(response, extraHeaders);
    }

    return new Response("Not Found", { status: 404 });
  },
};
