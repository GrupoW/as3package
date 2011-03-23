package  
{
	import asunit.textui.TestRunner;
	import flash.display.MovieClip;

	/**
	 * @author Raul Uranga
	 */
	public class WTestRunner extends MovieClip 
	{
		public function WTestRunner()
		{
			var unittests:TestRunner = new TestRunner();
			addChild(unittests);
			unittests.start(AllTests, null, TestRunner.SHOW_TRACE);
		}
	}
}
