package kex;

class StringApi {
	public static function sortAscending( a: String, b: String )
		return a < b ? -1 : a > b ? 1 : 0;

    public static function leadingZeros( value: Int, digits: Int ) : String {
        var s = Std.string(value);

        for (i in s.length...digits) {
            s = '0$s';
        }

        return s;
    }
}
