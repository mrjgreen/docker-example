module.exports = function buildRequestLogger(logger){
  return function(req,res,next){
    const startTime = process.hrtime();
    function doLog(){
      const diffTime = process.hrtime(startTime);
      logger.info({
        'ip':       req.ip || req.connection.remoteAddress || '127.0.0.1',
        'method':   req.method,
        'path':     (req.baseUrl || '') + (req.url || '-'),
        'status':   res.statusCode,
        'res-time': (diffTime[0] * 1e9 + diffTime[1]) / 1e6,
        'body':     req.body
      })
    }
    res.on('finish', doLog);
    res.on('close', doLog);
    next()
  }
}
