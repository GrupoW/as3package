package 
{
	import com.grupow.utils.StringUtils;
	import asunit.framework.TestCase; 

	public class StringUtilsTest extends TestCase 
	{

		public function StringUtilsTest(testMethod:String = null) 
		{
			super(testMethod);
		}

		protected override function setUp():void 
		{
			
		}

		protected override function tearDown():void 
		{
			
		}

		public function testaddZero():void 
		{
			var str:String = "9";
			assertEquals("009", StringUtils.addZero(str, 2));
		}
		
		public function testcropAt():void 
		{
			var str:String = "apple";
			assertEquals("app" ,StringUtils.cropAt(str,3));
		}
		
		public function testdosDigit():void 
		{
			var n:Number = 10;
			assertEquals("10" ,StringUtils.dosDigit(n));
		}
		
		public function testFormatNumber():void 
		{
			var n:Number = 1000;
			assertEquals("1,000.00" ,StringUtils.formatNumber(n,2));
		}
		
		public function testFormatTime():void 
		{
			var time:Number = 1000 * 60 * 4;
			assertEquals("00:04:00:00" ,StringUtils.formatTime(time));
		}
		
		public function testhas():void 
		{
			var time:Number = 1000 * 60 * 4;
			assertEquals(true ,StringUtils.has("hola mundo","mundo"));
		}
		
		public function testinsertat():void 
		{
			var message:String = "hola !!!";
			assertEquals("hola mundo!!!" ,StringUtils.insertAt(message," mundo",5));
		}
		
		public function testisEmail():void 
		{
			var email:String = "rur@domain.com";
			assertEquals(true ,StringUtils.isEmail(email));
		}
		
		public function testrepeat():void 
		{
			var c:String = "*";
			assertEquals("*****" ,StringUtils.repeat(c,5));
		}
		
		public function testTrim():void 
		{
			var message:String = "   *   ";
			assertEquals("*" ,StringUtils.trim(message));
		}
	}
}