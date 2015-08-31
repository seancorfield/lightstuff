<cfscript>
	/*
	ObjectXMLFilePath = expandPath("config/controller/admin.xml");
	ObjectType = "controller";
	ObjectCollectionsList = "methods";
	ControllerMetadata = createObject("component" , "com.pbell.basemetadata").init( ObjectType , ObjectCollectionsList , ObjectXMLFilePath );
	Controller = createObject("component" , "com.pbell.baseservice").init( ControllerMetadata );
*/

	ObjectXMLFilePath = expandPath("config/model/siteuser.xml");
	ObjectType = "domainObject";
	ObjectCollectionsList = "properties,methods,relationships";
	ServiceMetadata = createObject("component" , "com.pbell.basemetadata").init( ObjectType , ObjectCollectionsList , ObjectXMLFilePath );
	Service = createObject("component" , "com.pbell.baseservice").init( ServiceMetadata );
	

</cfscript>
<cfoutput>
	Service class says #Service.getAdminList( Filter="2=1" , AdminOnly=1)#<br />
</cfoutput>
