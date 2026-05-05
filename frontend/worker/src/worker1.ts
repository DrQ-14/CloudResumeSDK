//Worker1
export default {
  async fetch(request: Request, env: any, ctx: any) {
    const url = new URL(request.url);
    const pathname = url.pathname;

    // 1. HARD ROUTE LOCK (prevents API scanning / endpoint discovery)
    // Only allow known, explicit endpoints.
    const allowed = ["/api/ResumeCounter"];

    if (!allowed.includes(pathname)) {
      return new Response("Not Found", { status: 404 });
    }

    //  2. BASIC RATE LIMITING (simple in-memory version)
    //  NOTE: This is NOT globally accurate in Workers (edge is distributed)
    //  but works as a lightweight spam/refresh guard.
    const ip = request.headers.get("CF-Connecting-IP") || "unknown";

    // HANDLE CORS PREFLIGHT
    if (request.method === "OPTIONS") {
      return new Response(null, {
        headers: {
          "Access-Control-Allow-Origin": "https://www.tanager-solutions.com",
          "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
          "Access-Control-Allow-Headers": "Content-Type",
        },
      });
    }

    // simple in-memory store (resets on cold start)
    if (!globalThis.rateLimitStore) {
      globalThis.rateLimitStore = new Map();
    }

    const now = Date.now();
    const windowMs = 10 * 1000; // 10 seconds
    const limit = 20; // max requests per window

    const record = globalThis.rateLimitStore.get(ip) || [];

    // remove old requests outside window
    const recentRequests = record.filter((t: number) => now - t < windowMs);

    if (recentRequests.length >= limit) {
      return new Response("Too Many Requests", { status: 429 });
    }

    recentRequests.push(now);
    globalThis.rateLimitStore.set(ip, recentRequests);

    //  3. EDGE CACHING (huge performance + cost reduction)
    //  Caches Azure response at Cloudflare edge for 5–30 seconds
    const cache = caches.default;
    const cacheKey = new Request(url.toString(), request);

    let response = await cache.match(cacheKey);

    if (response) {
      // ⚠️ IMPORTANT: still add CORS to cached responses
      const cachedWithCors = new Response(response.body, response);
      cachedWithCors.headers.set(
        "Access-Control-Allow-Origin",
        "https://www.tanager-solutions.com",
      );
      cachedWithCors.headers.set(
        "Access-Control-Allow-Methods",
        "GET, POST, OPTIONS",
      );
      cachedWithCors.headers.set(
        "Access-Control-Allow-Headers",
        "Content-Type",
      );

      return cachedWithCors;
    }

    // 4. FORWARD REQUEST TO AZURE FUNCTION (origin)
    const targetUrl = env.AZURE_FUNCTION_URL + pathname + url.search;

    const forwardedRequest = new Request(targetUrl, request);

    // optional: origin protection secret
    forwardedRequest.headers.set("x-origin-secret", env.ORIGIN_SECRET);

    response = await fetch(forwardedRequest);

    // ===============================
    // 5. ADD CORS HEADERS (IMPORTANT)
    // ===============================

    const corsResponse = new Response(response.body, response);

    corsResponse.headers.set(
      "Access-Control-Allow-Origin",
      "https://www.tanager-solutions.com",
    );

    corsResponse.headers.set(
      "Access-Control-Allow-Methods",
      "GET, POST, OPTIONS",
    );

    corsResponse.headers.set("Access-Control-Allow-Headers", "Content-Type");

    // 6. CACHE THE CORS-FIXED RESPONSE
    cache.put(cacheKey, corsResponse.clone());

    return corsResponse;
  },
};
