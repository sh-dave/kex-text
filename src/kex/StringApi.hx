package kex;

class StringApi {
	public static function sortAscending( a: String, b: String )
		return a < b ? -1 : a > b ? 1 : 0;

	public static function leadingZeros( value: Int, digits: Int )
		return StringTools.lpad('$value', '0', digits);
}
