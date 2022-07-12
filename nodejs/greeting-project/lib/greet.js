const _ = require("lodash");

const GREETINGS = {
    en: "Good Morning",
    de: "Guten Morgen",
    fr: "Bonjour",
    ru: "Dobre Utra",
    kr: "Annyeonghaseyo"
};

exports.greet = function (code) {
    if (code) {
        if (!GREETINGS[code]) {
            return "Error! We don't support his language."
        } else {
            return GREETINGS[code];
        }
    }
    else {
        return GREETINGS['en'];
    }
}

exports.greetRandom = function () {
    return _.sample(_.values(GREETINGS));
}