import java.sql.CallableStatement ;
import org.identityconnectors.framework.common.objects.*;
import java.text.*;

// START HERE
System.out.println("[Liferay Create-Groovy] Attributes::"+attributes);

//Get all the attributes from script argument
String uid = attributes.get("__UID__")!=null? attributes.get("__UID__").getValue().get(0):null;
String login = attributes.get("SCREENNAME")!=null? attributes.get("SCREENNAME").getValue().get(0):null;
String firstName=attributes.get("FIRSTNAME")!=null? attributes.get("FIRSTNAME").getValue().get(0):null;
String lastName=attributes.get("LASTNAME")!=null? attributes.get("LASTNAME").getValue().get(0):null;
String email=attributes.get("EMAILADDRESS")!=null? attributes.get("EMAILADDRESS").getValue().get(0):null;
String password=attributes.get("PASSWORD")!=null? attributes.get("PASSWORD").getValue().get(0):null;
joindate = attributes.get("JOININGDATE")!=null? attributes.get("JOININGDATE").getValue().get(0):null;
enableValue = attributes.get("STATUS")!=null? attributes.get("STATUS").getValue().get(0):true;

CallableStatement createStmt = null;
try {
    //Initialize the prepare statement to insert the data into database table
    createStmt =   conn.prepareCall("{call create_liferay_user(?,?,?,?,?,?,?,?)}");
    //Set the input parameters
    /*
    create or replace PROCEDURE create_liferay_user
(  p_screenname          USER_.SCREENNAME%type
, p_FIRSTNAME        USER_.FIRSTNAME%type
, p_LASTNAME         USER_.LASTNAME%type
, p_EMAILADDRESS   USER_.EMAILADDRESS%type
, p_PASSWORD   USER_.PASSWORD_%type
)
    * */

    createStmt.setString(1, login);
    createStmt.setString(2, firstName);
    createStmt.setString(3, lastName);
    createStmt.setString(4, email);
    createStmt.setString(5, password);
    dateStr = null;
    //Convert the joindate into oracle date format
    if( joindate != null) {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.S");
        java.util.Date date= df.parse(joindate);
        DateFormat targetFormat = new SimpleDateFormat("dd-MMM-yy");
        dateStr = targetFormat.format(date);
    }
    createStmt.setString(6,null);
    if(enableValue)
        createStmt.setString(7,"0");
    else
        createStmt.setString(7,"5");
    //Execute sql statement
    createStmt.registerOutParameter(8, java.sql.Types.VARCHAR);
    createStmt.executeUpdate();
    uid = createStmt.getString(8);
} finally {
    //close the sql statements
    if (createStmt != null)
        createStmt.close();
}
System.out.println("[Create] Created User::"+uid);
//Return Uid from the script
return new Uid(uid);