const express = require("express");
const app = express();

app.get("/products", (req, res) => {
  res.json([
    { id: 1, name: "Laptop", price: 50000 },
    { id: 2, name: "Phone", price: 20000 }
  ]);
});

app.listen(4000, () => console.log("Product Service running"));