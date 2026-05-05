//Worker1
function withCors(response: Response) {
  const newResponse = new Response(response.clone().body, {
    status: response.status,
    statusText: response.statusText,
    headers: response.headers,
  });

  newResponse.headers.set(
    "Access-Control-Allow-Origin",
    "https://www.tanager-solutions.com",
  );

  newResponse.headers.set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");

  newResponse.headers.set("Access-Control-Allow-Headers", "Content-Type");

  return newResponse;
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

    const ip = request.headers.get("CF-Connecting-IP") || "unknown";

    if (!globalThis.rateLimitStore) {
      globalThis.rateLimitStore = new Map();
    }

    const now = Date.now();
    const windowMs = 10 * 1000;
    const limit = 20;

    const record = globalThis.rateLimitStore.get(ip) || [];
    const recentRequests = record.filter((t: number) => now - t < windowMs);

    if (recentRequests.length >= limit) {
      return withCors(new Response("Too Many Requests", { status: 429 }));
    }

    recentRequests.push(now);
    globalThis.rateLimitStore.set(ip, recentRequests);

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
