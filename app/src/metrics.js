// app/src/metrics.js
const client = require("prom-client");

// Create a Registry which registers the metrics
const register = new client.Registry();

// Default metrics (CPU, memory, etc.)
client.collectDefaultMetrics({ register });

// Custom metrics
const httpRequestDurationSeconds = new client.Histogram({
  name: "http_request_duration_seconds",
  help: "Duration of HTTP requests in seconds",
  labelNames: ["method", "route", "status_code"],
  buckets: [0.1, 0.5, 1, 1.5, 2, 5],
});

const httpRequestErrorsTotal = new client.Counter({
  name: "http_request_errors_total",
  help: "Total number of HTTP request errors",
  labelNames: ["method", "route", "status_code"],
});

register.registerMetric(httpRequestDurationSeconds);
register.registerMetric(httpRequestErrorsTotal);

// Middleware to measure request latency and errors
function metricsMiddleware(req, res, next) {
  const end = httpRequestDurationSeconds.startTimer();
  res.on("finish", () => {
    end({ method: req.method, route: req.path, status_code: res.statusCode });
    if (res.statusCode >= 400) {
      httpRequestErrorsTotal.inc({ method: req.method, route: req.path, status_code: res.statusCode });
    }
  });
  next();
}

module.exports = { register, metricsMiddleware };
