// sign up form
let form = document.getElementById("signup-form");

form.addEventListener("submit", function (event) {
  event.preventDefault();

  let formData = new FormData(form);
  let jsonObject = {};

  for (const [key, value] of formData.entries()) {
    jsonObject[key] = value;
  }
  // console.log(jsonObject);

  fetch("/signup", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(jsonObject),
  })
    .then((response) => response.json())
    .then((data) => console.log(data))
    .catch((error) => {
      console.error("Error:", error);
    });
});

// log in form
document
  .getElementById("signin-form")
  .addEventListener("submit", function (event) {
    event.preventDefault();

    let username = document.getElementById("signin-username").value;
    let password = document.getElementById("signin-password").value;

    fetch("/login", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        username: username,
        password: password,
      }),
    })
      .then((response) => response.json())
      .then((data) => console.log(data))
      .catch((error) => {
        console.error("Error:", error);
      });
  });

// for sending burn item from burn-form
document
  .getElementById("burn-form")
  .addEventListener("submit", function (event) {
    event.preventDefault();

    // add burn details here
    let fk_burn_user_id = document.getElementById("burn-user-id").value;
    let burn_img_path = document.getElementById("burn-image-path").value;
    let burn_date = document.getElementById("burn-date").value;

    fetch("/add_burn", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        fk_burn_user_id: fk_burn_user_id,
        burn_img_path: burn_img_path,
        burn_date: burn_date,
      }),
    })
      .then((response) => response.json())
      .then((data) => console.log(data))
      .catch((error) => {
        console.error("Error:", error);
      });
  });

document
  .getElementById("fetch-burns")
  .addEventListener("submit", function (event) {
    event.preventDefault();
    // add burn details here
    let fk_burn_user_id = document.getElementById("burn-user-id-fk").value;

    fetch("/get_burns", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        fk_burn_user_id: fk_burn_user_id,
      }),
    })
      .then((response) => response.json())
      .then((data) => console.log(data))
      .catch((error) => {
        console.error("Error:", error);
      });
  });

document
  .getElementById("fetch-users")
  .addEventListener("click", function (event) {
    event.preventDefault();
    // send get request to get all users
    fetch("/get_users")
      .then((response) => response.json())
      .then((data) => console.log(data))
      .catch((error) => {
        console.error("Error:", error);
      });
  });
