<cfoutput>
	<cfif structkeyexists( session , "message" )>
		Message: #session.message#<br />
		<cfset structDelete( session , "message" )>
	</cfif>
test view in the main views directory - main/test.cfm<br />

</cfoutput>