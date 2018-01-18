package kex.text;

class TextLayouter {
	public function new() {
	}

	public function layout( content: String, font: FontInfo, areaWidth: Float ) : TextLayout {
		if (content == null || content.length == 0) {
			return {
				lines: [],
				width: 0,
				height: 0,
			}
		}

		if (areaWidth <= 0) {
			return {
				lines: [content],
				width: font.width(content),
				height: font.height(),
			}
		}

		var maxWidth = areaWidth;
		var maxTextWidth = 0.0;
		var textWidth = 0.0;
		var lines: Array<String> = [];

		for (line in content.split('\n')) {
			var lineWidth = font.width(line);

			if (lineWidth > maxWidth) {
				var words = Lambda.list(line.split(' '));

				while (!words.isEmpty()) {
					line = words.pop();
					lineWidth = font.width(line);
					textWidth = Math.max(textWidth, lineWidth);
					maxTextWidth = Math.max(maxTextWidth, textWidth);
					var nextWord = words.pop();

					while (nextWord != null && (lineWidth = font.width('$line $nextWord')) <= maxWidth) {
						textWidth = Math.max(textWidth, lineWidth);
						maxTextWidth = Math.max(maxTextWidth, textWidth);
						line = '$line $nextWord';
						nextWord = words.pop();
					}

					if (line != '') {
						lines.push('$line');
					}

					if (nextWord != null) {
						words.push(nextWord);
					}
				}
			} else {
				textWidth = Math.max(textWidth, lineWidth);
				maxTextWidth = Math.max(maxTextWidth, textWidth);

				if (line != '') {
					lines.push(line);
				}
			}
		}

		return {
			lines: lines,
			width: maxTextWidth,
			height: font.height() * lines.length,
		}
	}
}
