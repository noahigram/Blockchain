// Setup movie night

// cook popcorn
// pour drinks
// start movie

async function setupMovieNight() {
  await cookPopcorn();
  await pourDrinks();
  startMovie(); //only start movie once popcorn and drinks are made
}

function cookPopcorn() {
  return Promise(/*Some code here */);
}
