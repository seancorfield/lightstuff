<cfcomponent extends="lightbase.com.pbell.base.basedatatype" output="false"><cfscript>

// ***************** PUBLIC METHODS *****************

function validateProperty( PropertyName , PropertyValue , DataTypeProperties ) {
	// Return a comma delimited list of error keye
	if ( NOT IsValid( "email" , arguments.PropertyValue ) ) {
		return "MalformedEmail";	
	}
	return "";
}

</cfscript>
</cfcomponent>