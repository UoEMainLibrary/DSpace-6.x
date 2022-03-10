package org.dspace.identifier;

import org.dspace.core.ReloadableEntity;

import javax.persistence.*;
import java.util.UUID;

@Entity
@Table(name = "Doicollection" )
public class DOICollection implements ReloadableEntity<Integer>  {
    @Id
    @Column(name="doicollection_id")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator="doicollection_seq")
    @SequenceGenerator(name="doicollection_seq", sequenceName="doicollection_seq", allocationSize = 1)
    private Integer id;

    @Column(name = "doicollection_uuid", unique = true)
    private UUID doicollection_uuid;

    protected DOICollection()
    {
    }

    public Integer getID() {
        return id;
    }

    public UUID getUUID() {
        return doicollection_uuid;
    }

    public void setUUID(UUID uuid) {
        this.doicollection_uuid = uuid;
    }

}
