const colours = require("tailwindcss/colors");

module.exports = {
  purge: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  mode: "jit",
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      colors: {
        gray: colours.trueGray,
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
};
