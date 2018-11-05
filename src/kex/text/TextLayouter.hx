package kex.text;

typedef TextLayouterOpts = {
	maxCharactersPerLine: Int,
}

class TextLayouter {
	var opts: TextLayouterOpts;

	static var defaultOpts = {
		maxCharactersPerLine: 66,
	}

	public function new( ?opts ) {
		this.opts = opts != null ? opts : defaultOpts;
	}

	public function layout( content: String, font: FontInfo, areaWidth: Float ) : TextLayout {
		if (content == null || content.length == 0) {
			return {
				lines: [],
				width: 0,
				height: 0,
				lineHeight: 0,
			}
		}

		var lineHeight = font.height();

		if (areaWidth <= 0) {
			var width = font.width(content);

			return {
				lines: [{ width: width, content: content }],
				width: width,
				height: font.height(),
				lineHeight: lineHeight,
			}
		}

		var maxWidth = areaWidth;
		var maxTextWidth = 0.0;
		var textWidth = 0.0;
		var lines: Array<TextLine> = [];

		for (line in content.split('\n')) {
			var lineWidth = font.width(line);

			if (lineWidth > maxWidth || line.length > opts.maxCharactersPerLine) {
				var words = Lambda.list(line.split(' '));

				while (!words.isEmpty()) {
					line = words.pop();
					lineWidth = font.width(line);
					textWidth = Math.max(textWidth, lineWidth);
					maxTextWidth = Math.max(maxTextWidth, textWidth);
					var nextWord = words.pop();

					while (true) {
						if (nextWord == null) {
							break;
						}

						var nextLine = '$line $nextWord';

						if (nextLine.length > opts.maxCharactersPerLine) {
							break;
						}

						if ((lineWidth = font.width(nextLine)) > maxWidth) {
							break;
						}

						textWidth = Math.max(textWidth, lineWidth);
						maxTextWidth = Math.max(maxTextWidth, textWidth);
						line = nextLine;
						nextWord = words.pop();
					}

					if (line != '') {
						lines.push({ content: line, width: lineWidth });
					}

					if (nextWord != null) {
						words.push(nextWord);
					}
				}
			} else {
				textWidth = Math.max(textWidth, lineWidth);
				maxTextWidth = Math.max(maxTextWidth, textWidth);

				if (line != '') {
					lines.push({ content: line, width: lineWidth });
				}
			}
		}

		return {
			lines: lines,
			width: maxTextWidth,
			height: font.height() * lines.length,
			lineHeight: lineHeight,
		}
	}
}
