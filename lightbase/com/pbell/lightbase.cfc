<cfcomponent output="false"><cfscript>
// ***************** PUBLIC METHODS *****************
function onApplicationStart() {
		setBeanFactory();
}

function onRequestStart() {
	onApplicationStart();
	event = getBeanFactory().getBean("event").load( URL ).load( form ).setup();
	callController( event );
}


// ***************** PRIVATE METHODS *****************

function callController( event ) {
	var BeanFactory = getBeanFactory();
	var Controller = "";
	var ControllerName = arguments.event.getControllerName() & "Controller";
	var ControllerMethod = arguments.event.getControllerMethod();
	var ViewContent = "";
	if ( BeanFactory.hasBean( ControllerName ) ) {
		Controller = BeanFactory.getBean( ControllerName );
		if ( Controller.hasMethod( ControllerMethod ) ) {
			evaluate("Controller.#ControllerMethod#( event=arguments.event )");
		}
	}
	ViewContent = saveView( event );
	writeOutput( ViewContent );
}

function setBeanFactory() {
	var BeanConfig = createObject("component","#this.name#.com.beanconfig").init( this.name );
	application.beanFactory = CreateObject("component","lightbase.lightwire.LightWire").init( BeanConfig );
}

function getBeanFactory() {
	return application.beanFactory;
}

</cfscript>
<cffunction name="saveView" returntype="string" output="false">
	<cfargument name="event" type="any" required="true">
	<cfset var ViewContent = "">
	<cfsavecontent variable="ViewContent"><cfinclude template="#event.getViewPath()#.cfm"></cfsavecontent>
	<cfreturn ViewContent>
</cffunction>
</cfcomponent>