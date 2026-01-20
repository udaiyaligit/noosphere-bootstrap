const util = require("util");

function jsonLog(level, obj, msg) {
  const out = Object.assign({}, obj || {}, {
    level,
    msg,
    timestamp: new Date().toISOString(),
  });
  console.log(JSON.stringify(out));
}

const logger = {
  info: (obj, msg) => jsonLog("info", obj, msg),
  error: (obj, msg) => jsonLog("error", obj, msg),
  warn: (obj, msg) => jsonLog("warn", obj, msg),
};

function httpLogger(req, res, next) {
  const start = Date.now();
  res.on("finish", () => {
    const entry = {
      method: req.method,
      url: req.url,
      statusCode: res.statusCode,
      durationMs: Date.now() - start,
      trace_id: req.headers["x-trace-id"],
    };
    logger.info(entry, "http request");
  });
  next();
}

module.exports = { logger, httpLogger };
