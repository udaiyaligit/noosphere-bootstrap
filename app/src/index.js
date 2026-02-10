const express = require("express");
const { v4: uuidv4 } = require("uuid");
const { logger, httpLogger } = require("./logger");
const { register, metricsMiddleware } = require("./metrics");

const app = express();
app.use(express.json());
app.use(httpLogger);
app.use(metricsMiddleware);

app.use((req, res, next) => {
  const traceIdHeader = req.headers["x-trace-id"];
  if (!traceIdHeader) {
    req.headers["x-trace-id"] = uuidv4();
  }
  res.setHeader("x-trace-id", req.headers["x-trace-id"]);
  next();
});

app.get("/health", async (req, res) => {
  try {
    const health = {
      status: "ok",
      timestamp: new Date().toISOString(),
      database: "ok",
    };
    logger.info(
      { trace_id: req.headers["x-trace-id"], health },
      "health check",
    );
    res.json(health);
  } catch (err) {
    logger.error(
      { err, trace_id: req.headers["x-trace-id"] },
      "health check failed",
    );
    res.status(500).json({ status: "error" });
  }
});

app.get("/api/data", (req, res) => {
  const payload = { message: "Hello from the Express API", items: [1, 2, 3] };
  logger.info({ trace_id: req.headers["x-trace-id"], payload }, "serve data");
  res.json(payload);
});

// Metrics endpoint for Prometheus
app.get("/metrics", async (req, res) => {
  try {
    res.set("Content-Type", register.contentType);
    res.end(await register.metrics());
  } catch (err) {
    res.status(500).end(err.toString());
  }
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  logger.info({ port }, "api started");
});
