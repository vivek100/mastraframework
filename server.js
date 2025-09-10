import express from 'express';

const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('Server is running on port ' + PORT);
});

app.listen(PORT, () => {
  console.log(`Express server listening on http://localhost:${PORT}`);
});
