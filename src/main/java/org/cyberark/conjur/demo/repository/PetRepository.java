package org.cyberark.conjur.demo.repository;

import org.cyberark.conjur.demo.model.Pet;
import org.springframework.data.repository.CrudRepository;

public interface PetRepository extends CrudRepository<Pet, Long> {
}