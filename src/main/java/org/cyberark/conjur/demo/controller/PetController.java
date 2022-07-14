package org.cyberark.conjur.demo.controller;

import org.cyberark.conjur.demo.model.Pet;
import org.cyberark.conjur.demo.repository.PetRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;

@RestController
@RequestMapping("/pet")
class PetController {
  @Autowired
  private PetRepository repository;

  @GetMapping("/{id}")
  ResponseEntity<Pet> getPet(@PathVariable Long id) {
      Pet pet = repository.findById(id).orElseThrow(null);
      if (pet == null) {
        return ResponseEntity.notFound().build();
      }

      return ResponseEntity.ok().body(pet);
  }

  @PostMapping()
  ResponseEntity<?> createPet(@RequestBody Pet pet) {
    if (pet == null) {
      return ResponseEntity.badRequest().body(null);
    }

    Pet result = repository.save(new Pet(pet.getName()));
    URI location = ServletUriComponentsBuilder
      .fromCurrentRequest().path("/{id}")
      .buildAndExpand(result.getId()).toUri();

    return ResponseEntity.created(location).build();
  }

  @DeleteMapping("/{id}")
  ResponseEntity<?> deletePet(@PathVariable Long id) {
    Pet pet = repository.findById(id).orElseThrow(null);
    if (pet == null) {
      return ResponseEntity.notFound().build();
    }

    repository.delete(pet);

    return ResponseEntity.ok().build();
  }
}