const colours = require("tailwindcss/colors");

module.exports = {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  mode: "jit",
  darkMode: 'media',
  theme: {
    extend: {
      colors: {
        gray: colours.neutral,
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
};
