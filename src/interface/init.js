(async () => {
  console.log("Loading global pyrun");
  global.python = await require("./interface")();
  global.python._init();
  global.pyeval = global.python.cwrap("pyeval", "string", ["string"]);
  console.log("Loaded and ready");
})();
