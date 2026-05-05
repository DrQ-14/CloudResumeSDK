export {};

declare global {
  var rateLimitStore: Map<string, number[]>;
}
