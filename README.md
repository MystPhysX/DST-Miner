# DST-Miner
Collab mod with ZupaleX

This will be an implementation of a miner for Do Not Starve Together.


To-Do:
- Start Work


Ideas:
- When the digging task is successful, a random number is generated between 1 and (3?) which will be the amount of item that digged.
- Then a random chaeck is made for each of thess successful digging products to know to which tiers it belongs (common, uncommon, rare, very rare, etc...)
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

Approved Ideas:
- Mines stone randomly at a random interval? E.g every segment (16 segments per day) a function runs with a chance of success (60-75%?). If the function suceeds then it has a chance of "digging up" any item from the list below.
- Above function has a chance to "jam" the miner if successful. Uses a wrench (new item) to unjam. 2x chance to jam in the summer.
- The chance of an item getting "dug up" depends on the biome in which the miner is placed.
- Miner spits item into chest.
- 2 wrenches. 1st is a basic wrench requiring vanilla items to craft. Unjams the machine once. Advanced wrench requires iron ore and unjams the machine 5(?) times.
- Miner slows down by 40% in the winter.
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
- The base periodic function

MystPhysX Currently Working on:


Job Done:
- Created the basic machine and gave it a "follower" prefab which acts like the storage.
- Setting up the storage widget. It is configurable (2x2, 2x3, 3x3, 3x4, 4x4). Working for client as well. If a modification is made on the artwork, please just replace the corresponding image file in the export folder by conserving the exact dimension. 
