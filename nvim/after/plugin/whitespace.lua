require("highlight-whitespace").setup({
	user_palette = {
		markdown = {
			tws = "RosyBrown",
			["\\(\\S\\)\\@<=\\s\\(\\.\\|,\\)\\@="] = "CadetBlue3",
			["\\(\\S\\)\\@<= \\{2,\\}\\(\\S\\)\\@="] = "SkyBlue1",
			["\\t\\+"] = "plum4",
		},
		other = {
			tws = "PaleVioletRed",
			["\\(\\S\\)\\@<=\\s\\(,\\)\\@="] = "coral1",
			["\\(\\S\\)\\@<= \\{2,\\}\\(\\S\\)\\@="] = "",
			["\\t\\+"] = "",
		},
	},
})
