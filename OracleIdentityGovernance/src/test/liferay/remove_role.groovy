import org.identityconnectors.framework.common.objects.*;

System.out.println("[Liferay removeMultiValuedAttributeScript-Groovy] Remove Child data::" + attributes);
childst = null;
childDataEOSet = null;
if (childst != null)
    childst.close();
if (attributes.get("ROLEID") != null) {
    String id = attributes.get("__UID__").getValue().get(0);
    childDataEOSet = attributes.get("ROLEID").getValue();
    System.out.println("[Liferay removeMultiValuedAttributeScript-Groovy] childDataEOSet data::" + childDataEOSet);
    childst = conn.prepareStatement("delete from USERS_ROLES where USERID =? and ROLEID =? and COMPANYID = 20202");
    if (childDataEOSet != null) {
        //Iterate through child data and insert into table
        System.out.println("[Liferay removeMultiValuedAttributeScript] Adding Role data.");
        for (iterator = childDataEOSet.iterator(); iterator.hasNext();) {
            role_id = iterator.next();
            if (role_id != null) {
                System.out.println("[Liferay removeMultiValuedAttributeScript] Removing Role with ID: " + role_id + " for user id : " + id);
                childst.setString(1, id);
                childst.setString(2, role_id);
                childst.executeUpdate();
                childst.clearParameters();
            }
        };
    }
}
