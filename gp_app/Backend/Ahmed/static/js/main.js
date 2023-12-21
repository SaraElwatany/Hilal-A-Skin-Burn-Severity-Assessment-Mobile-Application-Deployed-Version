// add action lister to the sign up form

// Assuming you have a form with the id 'myForm'
let form = document.getElementById('signup-form');

form.addEventListener('submit', function(event) {
    event.preventDefault();

    let formData = new FormData(form);
    let jsonObject = {};

    for (const [key, value]  of formData.entries()) {
        jsonObject[key] = value;
    }
    console.log(jsonObject);

    fetch('/signup', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(jsonObject),
    })
    .then(response => response.json())
    .then(data => console.log(data))
    .catch((error) => {
        console.error('Error:', error);
    });
});




// document.getElementById('signup-form').addEventListener('submit', function(event) {
//   // event.preventDefault();
//   console.log('submit button pressed');
//   // getting the data from the form (username, passwor, email, gender, height, weight, age, profession)
//   let username = document.getElementById('username').value;
//   let password = document.getElementById('password').value;
//   let email = document.getElementById('email').value;
//   let gender = document.getElementById('gender').value;
//   let height = document.getElementById('height').value;
//   let weight = document.getElementById('weight').value;
//   let age = document.getElementById('age').value;
//   let dob = document.getElementById('dob').value;
//   let profession = document.getElementById('profession').value;
//   let phone = document.getElementById('phone').value;

//   console.log('username: ', username);
//   console.log('password: ', password);
//   console.log('email: ', email);

//   fetch('/signup', {
//       method: 'POST',
//       headers: {
//           'Content-Type': 'application/json',
//       },
//       body: JSON.stringify({
//         'username': username,
//         'password': password,
//         'email': email, 
//         'height' : height,
//         'weight' : weight,
//         'gender' : gender,
//         'age' : age, 
//         'dob' : dob,
//         'profession' : profession,
//         'phone' : phone
//         }),
//   })
//   .then(response => response.json())
//   .then(data => console.log(data))
//   .catch((error) => {
//       console.error('Error:', error);
//   });
// });




document.getElementById('signin-form').addEventListener('submit', function(event) {
  event.preventDefault();

  let username = document.getElementById('signin-username').value;
  let password = document.getElementById('signin-password').value;

  fetch('/login', {
      method: 'POST',
      headers: {
          'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        'username': username,
        'password': password}),
  })
  .then(response => response.json())
  .then(data => console.log(data))
  .catch((error) => {
      console.error('Error:', error);
  });
});
