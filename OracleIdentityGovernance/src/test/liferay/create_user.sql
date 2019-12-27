create or replace PROCEDURE create_liferay_user(p_screenname USER_.SCREENNAME%type
                                               , p_FIRSTNAME USER_.FIRSTNAME%type
                                               , p_LASTNAME USER_.LASTNAME%type
                                               , p_EMAILADDRESS USER_.EMAILADDRESS%type
                                               , p_PASSWORD USER_.PASSWORD_%type
                                               , p_CREATEDATE USER_.CREATEDATE%type
                                               , p_STATUS USER_.STATUS%type
                                               , out_uid OUT VARCHAR2)
    IS
    user_id    VARCHAR2(100);
    contact_id VARCHAR2(100);
    group_id   VARCHAR2(100);
    resourcepermission_id   VARCHAR2(100);
    LAYOUTSET_ID   VARCHAR2(100);

BEGIN

    SELECT max(USERID) + 1
    INTO user_id
    FROM USER_;

    SELECT max(CONTACTID) + 1
    INTO contact_id
    FROM CONTACT_;

    SELECT max(GROUPID) + 1
    INTO group_id
    FROM GROUP_;

    SELECT max(RESOURCEPERMISSIONID) + 1
    INTO resourcepermission_id
    FROM resourcepermission;

   SELECT max(LAYOUTSETID) + 1
    INTO layoutset_id
    FROM LAYOUTSET;


    INSERT INTO USER_ (MVCCVERSION, userid, SCREENNAME, COMPANYID,
                       FIRSTNAME, LASTNAME, PASSWORD_, PASSWORDENCRYPTED, EMAILADDRESS, UUID_, STATUS, CREATEDATE,DEFAULTUSER)
    VALUES (8, user_id, p_screenname, 20202, p_FIRSTNAME, p_LASTNAME, p_PASSWORD, 0, p_EMAILADDRESS, SYS_GUID(),
            p_STATUS, sysdate,0);

    Insert into CONTACT_ (MVCCVERSION, CONTACTID, COMPANYID, USERID, USERNAME, CREATEDATE, MODIFIEDDATE, CLASSNAMEID,
                          CLASSPK, ACCOUNTID, PARENTCONTACTID, EMAILADDRESS, FIRSTNAME, MIDDLENAME, LASTNAME, PREFIXID,
                          SUFFIXID, MALE, BIRTHDAY, SMSSN, FACEBOOKSN, JABBERSN, SKYPESN, TWITTERSN, EMPLOYEESTATUSID,
                          EMPLOYEENUMBER, JOBTITLE, JOBCLASS, HOURSOFOPERATION)
    values (1, contact_id, 20202, user_id, p_screenname,
            sysdate,
            sysdate, 20087, user_id, 20203, 0,
            p_EMAILADDRESS, p_FIRSTNAME, '', p_LASTNAME, 1, 2, 1,
            to_timestamp('01-JAN-70 12.00.00.000000000 AM', 'DD-MON-RR HH.MI.SSXFF AM'), null, null, null, null, null,
            null, null, null, null, null);
    update USER_ set CONTACTID = contact_id where USER_.USERID = user_id;

    Insert into GROUP_ (MVCCVERSION, UUID_, GROUPID, COMPANYID, CREATORUSERID, CLASSNAMEID, CLASSPK, PARENTGROUPID,
                        LIVEGROUPID, TREEPATH, GROUPKEY, NAME, DESCRIPTION, TYPE_, MANUALMEMBERSHIP,
                        MEMBERSHIPRESTRICTION, FRIENDLYURL, SITE, REMOTESTAGINGGROUPCOUNT, INHERITCONTENT, ACTIVE_)
    values (1, SYS_GUID(), group_id, 20202, user_id, 20087, user_id, 0, 0,
            '/' || p_screenname || '/', group_id,
            null, null, 0, 1, 0, '/' || p_screenname, 0, 0, 0, 0);

    Insert into LAYOUTSET (MVCCVERSION, LAYOUTSETID, GROUPID, COMPANYID, CREATEDATE, MODIFIEDDATE, PRIVATELAYOUT,
                           LOGOID, THEMEID, COLORSCHEMEID, PAGECOUNT, LAYOUTSETPROTOTYPEUUID,
                           LAYOUTSETPROTOTYPELINKENABLED)
    values (2, layoutset_id , group_id, 20202, sysdate,
            sysdate, 1, 0,
            'uservertical_WAR_userverticaltheme', '01', 1, null, 0);
    Insert into LAYOUTSET (MVCCVERSION, LAYOUTSETID, GROUPID, COMPANYID, CREATEDATE, MODIFIEDDATE, PRIVATELAYOUT,
                           LOGOID, THEMEID, COLORSCHEMEID, PAGECOUNT, LAYOUTSETPROTOTYPEUUID,
                           LAYOUTSETPROTOTYPELINKENABLED)
    values (2, layoutset_id + 1, group_id, 20202, sysdate,
            sysdate, 0, 0,
            'userhorizontal_WAR_userhorizontaltheme', '01', 1, null, 0);

    Insert into HR.RESOURCEPERMISSION (MVCCVERSION, RESOURCEPERMISSIONID, COMPANYID, NAME, SCOPE, PRIMKEY, PRIMKEYID,
                                       ROLEID, OWNERID, ACTIONIDS, VIEWACTIONID)
    values (0, resourcepermission_id, 20202, 'com.liferay.portal.kernel.model.User', 4, user_id, user_id, 20209, 20250, 31, 1);

    -- insert into Users_Groups values ($batchUserId, $guestGroupId);


    --insert into Users_Orgs (userId, organizationId) values ($batchUserId, $incOrganizationId );



    insert into Users_Roles(roleid,companyid, USERID) values (20211, 20202, user_id);
    out_uid := user_id;
END create_liferay_user;