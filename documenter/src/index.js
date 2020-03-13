const { Elm } = require("./elm.js");
const fs = require("fs");

const app = Elm.Main.init();

app.ports.createFile.subscribe(({ name, content }) =>
  fs.writeFile("./src/" + name, content, err => {
    if (err) throw err;
    console.log("The file has been saved!");
  })
);
