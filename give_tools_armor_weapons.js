console.clear();

var enchantments = {
  aquaAffinity: {
    item: [
      'helmet'
    ],
    id: 6,
    lvl: 1
  },
  baneOfArthropods: {
    item: [
      'sword',
      'axe'
    ],
    id: 18,
    lvl: 5
  },
  blastProtection: {
    item: [
      'helmet',
      'chestplate',
      'leggings',
      'boots'
    ],
    id: 3,
    lvl: 4
  },
  depthStrider: {
    item: [
      'boots'
    ],
    id: 8,
    lvl: 3
  },
  efficiency: {
    item: [
      'axe',
      'pickaxe',
      'shovel',
      'shears'
    ],
    id: 32,
    lvl: 5
  },
  featherFalling: {
    item: [
      'boots'
    ],
    id: 2,
    lvl: 4
  },
  fireAspect: {
    item: [
      'sword'
    ],
    id: 20,
    lvl: 2
  },
  fireProtection: {
    item: [
      'helmet',
      'chestplate',
      'leggings',
      'boots'
    ],
    id: 1,
    lvl: 4
  },
  flame: {
    item: [
      'bow'
    ],
    id: 50,
    lvl: 1
  },
  fortune: {
    item: [
      'axe',
      'pickaxe',
      'shovel'
    ],
    id: 35,
    lvl: 3
  },
  frostWalker: {
    item: [
      //'boots'
    ],
    id: 9,
    lvl: 2
  },
  infinity: {
    item: [
      'bow'
    ],
    id: 51,
    lvl: 1
  },
  knockback: {
    item: [
      'sword'
    ],
    id: 19,
    lvl: 2
  },
  looting: {
    item: [
      'sword'
    ],
    id: 21,
    lvl: 3
  },
  luckOfTheSea: {
    item: [
      'fishing rod'
    ],
    id: 61,
    lvl: 3
  },
  lure: {
    item: [
      'fishing rod'
    ],
    id: 62,
    lvl: 3
  },
  mending: {
    item: [
      'shield'
    ],
    id: 70,
    lvl: 1
  },
  power: {
    item: [
      'bow'
    ],
    id: 48,
    lvl: 5
  },
  projectileProtection: {
    item: [
      'helmet',
      'chestplate',
      'leggings',
      'boots'
    ],
    id: 4,
    lvl: 4
  },
  protection: {
    item: [
      'helmet',
      'chestplate',
      'leggings',
      'boots'
    ],
    id: 0,
    lvl: 4
  },
  punch: {
    item: [
      'bow'
    ],
    id: 49,
    lvl: 2
  },
  respiration: {
    item: [
      'helmet'
    ],
    id: 5,
    lvl: 3
  },
  sharpness: {
    item: [
      'sword',
      'axe'
    ],
    id: 16,
    lvl: 4
  },
  silkTouch: {
    item: [
      'axe',
      'pickaxe',
      'shovel'
    ],
    id: 33,
    lvl: 1
  },
  smite: {
    item: [
      'sword',
      'axe'
    ],
    id: 17,
    lvl: 5
  },
  sweepingEdge: {
    item: [
      'sword'
    ],
    id: 22,
    lvl: 3
  },
  thorns: {
    item: [
      'helmet',
      'chestplate',
      'leggings',
      'boots'
    ],
    id: 7,
    lvl: 3
  },
  unbreaking: {
    item: [
      'helmet',
      'chestplate',
      'leggings',
      'boots',
      'elytra',
      'sword',
      'axe',
      'pickaxe',
      'shovel',
      'shears',
      'bow',
      'fishing rod',
      'hoe',
      'shield'
    ],
    id: 34,
    lvl: 3
  }
};

var items = {
  'sword': {
    name: 'diamond_sword',
    qty: 1,
    display: 'Sword of the Spirit'
  },
  'bow': {
    name: 'bow',
    qty: 1,
    display: 'Fire Bow of Artemis'
  },
  'helmet': {
    name: 'diamond_helmet',
    qty: 1,
    display: 'Helmet of Salvation and Breathing'
  },
  'chestplate': {
    name: 'diamond_chestplate',
    qty: 1,
    display: 'Breastplate of Righteousness and Major Defense'
  },
  'leggings': {
    name: 'diamond_leggings',
    qty: 1,
    display: 'Shiny Pants'
  },
  'boots': {
    name: 'diamond_boots',
    qty: 1,
    display: 'Boots of the Gospel and Water Walking'
  },
  'shield': {
    name: 'shield',
    qty: 1,
    display: 'Shield of Faith and Regeneration'
  },
  'shovel': {
    name: 'diamond_shovel',
    qty: 1,
    display: 'Fast Digger'
  },
  'pickaxe': {
    name: 'diamond_pickaxe',
    qty: 1,
    display: 'Fast Picker'
  },
  'axe': {
    name: 'diamond_axe',
    qty: 1,
    display: 'Fast Chopper'
  },
  'hoe': {
    name: 'diamond_hoe',
    qty: 1,
    display: 'Fast Gardener'
  },
  'hopper': {
    name: 'hopper',
    qty: 64,
    display: 'Hopper'
  },
  'arrow': {
    name: 'arrow',
    qty: 64,
    display: 'Arrows of Legolas'
  }
};


for (var item in items) {
  if (!items.hasOwnProperty(item)) {
    continue;
  }
  
  var cmd = '/give @p minecraft:' + items[item].name + ' ' + items[item].qty + ' 0 {display:{Name:"' + items[item].display + '"}';
  var enchants = [];
  for (var enchantment in enchantments) {
    if (!enchantments.hasOwnProperty(enchantment)) {
      continue;
    }
    
    var enchant = enchantments[enchantment];
    if (enchant.item.indexOf(item) > -1) {
      enchants.push('{id:' + enchant.id + ',lvl:' + enchant.lvl + '}');
    }
  } // end enchantments
  
  if (enchants.length > 0) {
    cmd += ',ench:[';
    cmd += enchants.join(',');
    cmd += ']';
  }
  
  cmd += '}';
  
  console.log(cmd);
}
