import org.identityconnectors.framework.common.objects.*;

System.out.println("[Liferay addMultiValuedAttributeScript-Groovy] Adding Child data::" + attributes);
childst = null;
childDataEOSet = null;
if (childst != null)
    childst.close();
if (attributes.get("ROLEID") != null) {
    String id = attributes.get("__UID__").getValue().get(0);
    childDataEOSet = attributes.get("ROLEID").getValue();
    System.out.println("[Liferay addMultiValuedAttributeScript-Groovy] childDataEOSet data::" + childDataEOSet);
    childst = conn.prepareStatement("INSERT INTO USERS_ROLES(USERID,ROLEID,COMPANYID) VALUES (?,?,20202)");
    if (childDataEOSet != null) {
        //Iterate through child data and insert into table
        System.out.println("[Liferay addMultiValuedAttributeScript] Adding Role data.");
        for (iterator = childDataEOSet.iterator(); iterator.hasNext();) {
            role_id = iterator.next();
            if (role_id != null) {
                System.out.println("[Liferay addMultiValuedAttributeScript] Adding Role with ID: " + role_id + " for user id : " + id);
                childst.setString(1, id);
                childst.setString(2, role_id);
                childst.executeUpdate();
                childst.clearParameters();
            }
        };
    }
}
