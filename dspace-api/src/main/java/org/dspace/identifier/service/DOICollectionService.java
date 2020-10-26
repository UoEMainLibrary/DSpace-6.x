/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.identifier.service;

import org.dspace.core.Context;
import org.dspace.identifier.DOICollection;

import java.sql.SQLException;
import java.util.UUID;

/**
 * Service interface class for the DOI object.
 * The implementation of this class is responsible for all business logic calls for the DOI object and is autowired by spring
 *
 * @author kevinvandevelde at atmire.com
 */
public interface DOICollectionService {

    public DOICollection create(Context context) throws SQLException;

    public void delete(Context context, DOICollection doiCollection) throws SQLException;

    public DOICollection findByCollectionUUID(Context context, UUID collection_id) throws SQLException;

}
