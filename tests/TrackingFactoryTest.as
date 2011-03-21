package 
{
	import asunit.framework.TestCase; 
	import com.grupow.tracking.TrackingFactory;
	import com.grupow.tracking.ITrackable;
	import com.grupow.commands.TrackerTrackCommand;

	public class TrackingFactoryTest extends TestCase 
	{
		var tracker:ITrackable;
		public function TrackingFactoryTest(testMethod:String = null) 
		{
			super(testMethod);
		}

		protected override function setUp():void 
		{
			tracker = TrackingFactory.create(TrackingFactory.GOOGLE_ANALYTICS);
		}

		protected override function tearDown():void 
		{
			tracker = null;
		}

		public function testGA_creation():void 
		{
			assertNotNull(tracker);
		}
		
		public function testGATrack():void 
		{
			tracker.track("hello");
		}
		
		public function testGATrack_command():void 
		{
			var cmd:TrackerTrackCommand = new TrackerTrackCommand(tracker,"hello command");
			cmd.execute();
		}
	}
}