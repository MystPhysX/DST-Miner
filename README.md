# DST-Miner
Collab mod with ZupaleX

This will be an implementation of a miner for Do Not Starve Together.


To-Do:
- Start Work


Ideas:
- Add upgrades for the Machines
  - One of the upgrade could be something which tries to automatically unjam a jammed machine once per segment
  - One could improve the odds to mine higher tier items.
  - One could increase the amount of items per digging
  - One could override the behavior of the stuff : instead of digging material it would mainly "dig" mobs
- Add a new mob : Skeleton
  - It would pop in the cemetry when a digging machine is placed there 

Approved Ideas:
- 2 wrenches. 1st is a basic wrench requiring vanilla items to craft. Unjams the machine once. Advanced wrench requires iron ore and unjams the machine 5(?) times.
- Lasts for 5 days on a full fuel bar. Mole fills 2 days.

List of Diggable items (configurable):
- Stone (common)
- Flint (common)
- Nitre (common)
- Gold (uncommon)
- New Material : Iron Ore (uncommon) (depends on biome)
- Bone Shards (uncommon)
- Gems (rare) (depends on biome)
- Trinkets (rare)
- Moon Rocks (very rare) (depends on biome)


ZupaleX Currently Working on:

MystPhysX Currently Working on:


Job Done:
- Created the basic machine and gave it a "follower" prefab which acts like the storage.
- Setting up the storage widget. It is configurable (2x2, 2x3, 3x3, 3x4, 4x4). Working for client as well. If a modification is made on the artwork, please just replace the corresponding image file in the export folder by conserving the exact dimension. 
- Mines stone every 2 segments a function runs with a chance of success (60-75%?). If the function suceeds then it has a chance of "digging up" any item from the list above.
- Then a random check is made for each of thess successful digging products to know to which tiers it belongs (common, uncommon, rare, very rare, etc...)
- Then inside each tier, the items have their own probability
  - Example
    - Tier 1 : common
      - rocks = 33%
      - flint = 33%
      - nitre = 33%
    - Tier 2 : uncommon
      -  Iron Ore = 50%
      -  Bone Shard = 30%
      -  Gold Nugget = 20%
    - Etc...
- The chance of an item getting "dug up" depends on the biome in which the miner is placed.
- There is a chance after a successful digging that a cave monster appear when you open the storage (one that could fit in the pipe still)
- Above function has a chance to "jam" the miner if successful. Uses a wrench (new item) to unjam. 2x chance to jam in the summer.
- Miner slows down by 40% in the winter.
- Fueled Component implemented. Mole restore 2 days out of the 5 (50%) or does nothing (40%) or reverse the jam state of the machine (10%)
