/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.identifier.dao.impl;

import org.dspace.core.Context;
import org.dspace.core.AbstractHibernateDAO;
import org.dspace.identifier.DOICollection;
import org.dspace.identifier.dao.DOICollectionDAO;
import org.hibernate.Criteria;
import org.hibernate.criterion.Restrictions;

import java.sql.SQLException;
import java.util.UUID;

/**
 * Hibernate implementation of the Database Access Object interface class for the DOI object.
 * This class is responsible for all database calls for the DOI object and is autowired by spring
 * This class should never be accessed directly.
 *
 * @author kevinvandevelde at atmire.com
 */
public class DOICollectionDAOImpl extends AbstractHibernateDAO<DOICollection> implements DOICollectionDAO
{
    protected DOICollectionDAOImpl()
    {
        super();
    }

    @Override
    public DOICollection findByCollectionUUID(Context context, UUID collection_id) throws SQLException {
        Criteria criteria = createCriteria(context, DOICollection.class);
        criteria.add(Restrictions.eq("doicollection_uuid", collection_id));
        return uniqueResult(criteria);
    }

}
