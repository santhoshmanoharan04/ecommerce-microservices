const express = require("express");
const app = express();

app.get("/cart", (req, res) => {
  res.json({ items: [] });
});

app.listen(5000, () => console.log("Cart Service running"));