/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.identifier;

import org.apache.log4j.Logger;
import org.dspace.content.DSpaceObject;
import org.dspace.core.Context;
import org.dspace.identifier.dao.DOICollectionDAO;
import org.dspace.identifier.service.DOICollectionService;
import org.springframework.beans.factory.annotation.Autowired;

import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

/**
 * Service implementation for the DOI object.
 * This class is responsible for all business logic calls for the DOI object and is autowired by spring.
 * This class should never be accessed directly.
 *
 * @author kevinvandevelde at atmire.com
 */
public class DOICollectionServiceImpl implements DOICollectionService {

    private static final Logger log = Logger.getLogger(DOICollectionServiceImpl.class);

    @Autowired(required = true)
    protected DOICollectionDAO doiCollectionDAO;

    protected DOICollectionServiceImpl()
    {

    }

    @Override
    public void delete(Context context, DOICollection doiCollection) throws SQLException {
        doiCollectionDAO.delete(context, doiCollection);
    }

    @Override
    public DOICollection create(Context context) throws SQLException {
        return doiCollectionDAO.create(context, new DOICollection());
    }

    @Override
    public DOICollection findByCollectionUUID(Context context, UUID collection_id) throws SQLException {
        return doiCollectionDAO.findByCollectionUUID(context, collection_id);
    }
}
