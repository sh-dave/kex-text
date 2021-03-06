package kex.text;

class TextLayouter {
	public static function layout( content: String, metrics: FontMetrics, areaWidth: Float, ?opts: TextLayoutOpts ) : TextLayout {
		final MaxCharactersPerLine = opts != null && opts.maxCharactersPerLine != null ? opts.maxCharactersPerLine : 66;
		final KeepNewlines = opts != null && opts.keepNewlines != null ? opts.keepNewlines : true;
		final lineSpacing = opts != null && opts.lineSpacing != null ? opts.lineSpacing : 1.0;
		final lineHeight = metrics.measureHeight() * lineSpacing;

		if (content == null || content.length == 0) {
			return {
				lines: KeepNewlines ? [{ content: '', width: 0}] : [],
				width: 0,
				height: KeepNewlines ? lineHeight : 0,
				lineHeight: KeepNewlines ? lineHeight : 0,
			}
		}

		if (areaWidth <= 0) {
			final width = metrics.measureWidth(content);

			return {
				lines: [{ width: width, content: content }],
				width: width,
				height: lineHeight,
				lineHeight: lineHeight,
			}
		}

		final maxWidth = areaWidth;
		var maxTextWidth = 0.0;
		var textWidth = 0.0;
		final lines: Array<TextLine> = [];

		for (line in content.split('\n')) {
			var lineWidth = metrics.measureWidth(line);

			if (lineWidth > maxWidth || line.length > MaxCharactersPerLine) {
				var words = Lambda.list(line.split(' '));

				while (!words.isEmpty()) {
					line = words.pop();
					lineWidth = metrics.measureWidth(line);
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

						final tmpWidth = metrics.measureWidth(nextLine);
						if (tmpWidth > maxWidth) {
							break;
						}

						lineWidth = tmpWidth;
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
			height: lineHeight * lines.length,
			lineHeight: lineHeight,
		}
	}
}
