class Transaction < ActiveRecord::Base

  belongs_to :balance
  belongs_to :activity
  belongs_to :sender,   class_name: "User"
  belongs_to :receiver, class_name: "User"

  delegate :name, to: :sender,   prefix: true
  delegate :name, to: :receiver, prefix: true
  delegate :name, to: :activity, prefix: true

  GUIDELINES =
    [['BlogPost Inbound', 40],
    ['Blog tech', 20],
    ['Pizza Sessie', 40],
    ['Lunch&Learn', 20],
    ['Elkaar uitzonderlijk helpen', 10],
    ['Call for Proposal indienen conferentie', 20],
    ['Spreken op conferentie', 100],
    ['Project RefCasse', 40],
    ['Bezoek conferentie', 20],
    ['Project Scoren >50 uur', 250],
    ['Consultancy Opdracht', 50],
    ['Medewerker die wordt aangenomen', 100],
    ['Lead aanbrengen/ Potential ook bij bestaande klant Alles wat potental wordt in ZOHO', 40],
    ['Meeting op tijd beginnen', 1],
    ['Marge / maand super (>=12% ROS)', 500],
    ['Marge / maand goed (>= 8% ROS <=12%)', 200],
    ['Marge / maand matig (>= 4% ROS <=8%)', 100],
    ['Omzet / maand super (>= 220k)', 500],
    ['Omzet / maand goed (>= 200k; <= 220k)', 200],
    ['Omzet / maand matig (>= 180k <= 200k)', 100],
    ['Een klanttevredenheidscijfer ophalen', 40],
    ['Een goede klanttevredenheid', 80],
    ['Quote van de klant voor website', 100],
    ['Event met externe bezoekers organiseren (code retreat, ontbijt sessie etc)', 50]]

end
