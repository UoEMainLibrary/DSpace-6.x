/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.identifier.dao;

import org.dspace.core.Context;
import org.dspace.core.GenericDAO;
import org.dspace.identifier.DOICollection;
import java.sql.SQLException;

import java.util.UUID;

/**
 * Database Access Object interface class for the DOI object.
 * The implementation of this class is responsible for all database calls for the DOI object and is autowired by spring
 * This class should only be accessed from a single service and should never be exposed outside of the API
 *
 * @author kevinvandevelde at atmire.com
 */
public interface DOICollectionDAO extends GenericDAO<DOICollection>
{
    public DOICollection findByCollectionUUID(Context context, UUID collection_id) throws SQLException;
}