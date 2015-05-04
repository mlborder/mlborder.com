# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

EventType.create([
  { name: 'unknown' },
  { name: 'fes_raid' },
  { name: 'choco_marathon' },
  { name: 'lesson_tower' },
  { name: 'imc_gvg' },
  { name: 'psl_marathon' }
])
