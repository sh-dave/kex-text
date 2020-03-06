package kex.text;

typedef TextLayouterOpts = {
	final ?maxCharactersPerLine: Int;
	final ?keepNewlines: Bool;
}

class TextLayouter {
	final MaxCharactersPerLine: Int;
	final KeepNewlines: Bool;

	public function new( ?opts: TextLayouterOpts ) {
		MaxCharactersPerLine = opts != null && opts.maxCharactersPerLine != null ? opts.maxCharactersPerLine : 66;
		KeepNewlines = opts != null && opts.keepNewlines != null ? opts.keepNewlines : true;
	}

	public function layout( content: String, font: FontInfo, areaWidth: Float ) : TextLayout {
		final lineHeight = font.height();

		if (content == null || content.length == 0) {
			return {
				lines: KeepNewlines ? [{ content: '', width: 0}] : [],
				width: 0,
				height: KeepNewlines ? lineHeight : 0,
				lineHeight: KeepNewlines ? lineHeight : 0,
			}
		}

		if (areaWidth <= 0) {
			final width = font.width(content);

			return {
				lines: [{ width: width, content: content }],
				width: width,
				height: font.height(),
				lineHeight: lineHeight,
			}
		}

		final maxWidth = areaWidth;
		var maxTextWidth = 0.0;
		var textWidth = 0.0;
		final lines: Array<TextLine> = [];

		for (line in content.split('\n')) {
			var lineWidth = font.width(line);

			if (lineWidth > maxWidth || line.length > MaxCharactersPerLine) {
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

						final nextLine = '$line $nextWord';

						if (nextLine.length > MaxCharactersPerLine) {
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
