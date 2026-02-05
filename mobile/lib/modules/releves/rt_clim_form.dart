import 'package:flutter/material.dart';
import 'package:assistant_entreiten_chaudiere/utils/mixins/form_field_builder_mixin.dart';
import 'package:assistant_entreiten_chaudiere/utils/mixins/form_state_mixin.dart';
import 'package:assistant_entreiten_chaudiere/utils/mixins/snackbar_mixin.dart';
import 'package:assistant_entreiten_chaudiere/utils/mixins/controller_dispose_mixin.dart';
import 'package:assistant_entreiten_chaudiere/utils/mixins/pagination_mixin.dart';
import 'package:assistant_entreiten_chaudiere/utils/mixins/photo_section_mixin.dart';

/// Relevé Technique Climatisation - Formulaire complet 3 pages
/// 133 champs + 4 photos
class RTClimForm extends StatefulWidget {
  const RTClimForm({super.key});

  @override
  State<RTClimForm> createState() => _RTClimFormState();
}

class _RTClimFormState extends State<RTClimForm>
    with
        FormFieldBuilderMixin,
        FormStateMixin,
        SnackBarMixin,
        ControllerDisposeMixin,
        PaginationMixin,
        PhotoSectionMixin {
  final _formKey = GlobalKey<FormState>();

  // ===== CONTROLLERS PAGE 1 (Infos + Électricité) =====
  late TextEditingController ctrlNomClient;
  late TextEditingController ctrlAdresseFact;
  late TextEditingController ctrlEmail;
  late TextEditingController ctrlTelFixe;
  late TextEditingController ctrlTelMobile;
  late TextEditingController ctrlRTName;
  late TextEditingController ctrlTechnicien;
  late TextEditingController ctrlAdresseInst;
  late TextEditingController ctrlSurface;
  late TextEditingController ctrlNbOccupants;
  late TextEditingController ctrlAnneeConst;
  late TextEditingController ctrlPieces;
  late TextEditingController ctrlCommentTGBT;
  late TextEditingController ctrlDistTableau;
  late TextEditingController ctrlPuissanceAbo;
  late TextEditingController ctrlCheminement;
  late TextEditingController ctrlTensionV;
  late TextEditingController ctrlEmplacements;
  late TextEditingController ctrlConsoAnnuelle;
  late TextEditingController ctrlCoutAnnuel;
  late TextEditingController ctrlIntensiteA;
  late TextEditingController ctrlNbEmplacSupplt;

  // ===== CONTROLLERS PAGE 2 (Groupes Ext & Int) =====
  late TextEditingController ctrlPieceGroupeExt;
  late TextEditingController ctrlDistObstacle;
  late TextEditingController ctrlHauteurFixation;
  late TextEditingController ctrlEvacCondensatsExt;
  late TextEditingController ctrlPieceInt;
  late TextEditingController ctrlEvacCondensatsInt;
  late TextEditingController ctrlSurfaceClim;
  late TextEditingController ctrlVolumeClim;
  late TextEditingController ctrlEpaisseurMur;
  late TextEditingController ctrlLongRaccordement;
  late TextEditingController ctrlHauteurPieceClim;
  late TextEditingController ctrlPuissanceUnite;
  late TextEditingController ctrlNatureMur;
  late TextEditingController ctrlDenivele;

  // ===== CONTROLLERS PAGE 3 (Souhait + Commentaires) =====
  late TextEditingController ctrlMarqueClient;
  late TextEditingController ctrlModeleClient;
  late TextEditingController ctrlCommentaire;
  late TextEditingController ctrlInfoMagasin;
  late TextEditingController ctrlTravaux;
  late TextEditingController ctrlTempCircuit;

  // ===== STATES PAGE 1 =====
  String _typeLogement = 'Appartement';
  String _electricite = 'EDF';
  String _typeRaccordement = 'Monophase';
  String _cheminement = 'Goulotte Int';

  bool _amiante = false;
  bool _accordCoProp = false;
  bool _tableauConforme = true;
  bool _diff30ma = true;
  bool _besoinTableauSupp = false;

  // ===== STATES PAGE 2 =====
  String _typePompageExt = 'Non';
  String _typePompageInt = 'Non';
  String _natureMurType = 'Parpaing';

  bool _groupeSurChaise = false;
  bool _groupeSurDalle = true;

  // ===== STATES PAGE 3 =====
  String _financementSouhaite = 'Non';

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    loadFormData();
  }

  void _initializeControllers() {
    // Page 1
    ctrlNomClient = registerController(TextEditingController());
    ctrlAdresseFact = registerController(TextEditingController());
    ctrlEmail = registerController(TextEditingController());
    ctrlTelFixe = registerController(TextEditingController());
    ctrlTelMobile = registerController(TextEditingController());
    ctrlRTName = registerController(TextEditingController());
    ctrlTechnicien = registerController(TextEditingController());
    ctrlAdresseInst = registerController(TextEditingController());
    ctrlSurface = registerController(TextEditingController());
    ctrlNbOccupants = registerController(TextEditingController());
    ctrlAnneeConst = registerController(TextEditingController());
    ctrlPieces = registerController(TextEditingController());
    ctrlCommentTGBT = registerController(TextEditingController());
    ctrlDistTableau = registerController(TextEditingController());
    ctrlPuissanceAbo = registerController(TextEditingController());
    ctrlCheminement = registerController(TextEditingController());
    ctrlTensionV = registerController(TextEditingController());
    ctrlEmplacements = registerController(TextEditingController());
    ctrlConsoAnnuelle = registerController(TextEditingController());
    ctrlCoutAnnuel = registerController(TextEditingController());
    ctrlIntensiteA = registerController(TextEditingController());
    ctrlNbEmplacSupplt = registerController(TextEditingController());

    // Page 2
    ctrlPieceGroupeExt = registerController(TextEditingController());
    ctrlDistObstacle = registerController(TextEditingController());
    ctrlHauteurFixation = registerController(TextEditingController());
    ctrlEvacCondensatsExt = registerController(TextEditingController());
    ctrlPieceInt = registerController(TextEditingController());
    ctrlEvacCondensatsInt = registerController(TextEditingController());
    ctrlSurfaceClim = registerController(TextEditingController());
    ctrlVolumeClim = registerController(TextEditingController());
    ctrlEpaisseurMur = registerController(TextEditingController());
    ctrlLongRaccordement = registerController(TextEditingController());
    ctrlHauteurPieceClim = registerController(TextEditingController());
    ctrlPuissanceUnite = registerController(TextEditingController());
    ctrlNatureMur = registerController(TextEditingController());
    ctrlDenivele = registerController(TextEditingController());

    // Page 3
    ctrlMarqueClient = registerController(TextEditingController());
    ctrlModeleClient = registerController(TextEditingController());
    ctrlCommentaire = registerController(TextEditingController());
    ctrlInfoMagasin = registerController(TextEditingController());
    ctrlTravaux = registerController(TextEditingController());
    ctrlTempCircuit = registerController(TextEditingController());
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relevé Technique Climatisation'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Column(
        children: [
          buildProgressBar(),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (page) => setState(() => currentPage = page),
              children: [
                _buildPage1(),
                _buildPage2(),
                _buildPage3(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// PAGE 1: INFOS GÉNÉRALES + ÉLECTRICITÉ
  Widget _buildPage1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            buildPageHeader('Infos & Électricité', Icons.electrical_services, Colors.teal),
            const SizedBox(height: 12),
            buildSection('Client (6 champs)', [
              buildTextField(ctrlNomClient, 'Nom du client'),
              buildTextField(ctrlAdresseFact, 'Adresse facturation', maxLines: 2),
              buildTextField(ctrlEmail, 'Email', keyboardType: TextInputType.emailAddress),
              buildTextField(ctrlTelFixe, 'Téléphone fixe', keyboardType: TextInputType.phone),
              buildTextField(ctrlTelMobile, 'Téléphone mobile', keyboardType: TextInputType.phone),
            ]),
            buildSection('Informations Générales', [
              buildTextField(ctrlRTName, 'Nom RT'),
              buildTextField(ctrlTechnicien, 'Technicien'),
              buildTextField(ctrlAdresseInst, 'Adresse installation', maxLines: 2),
            ]),
            buildSection('Environnement (7 champs)', [
              buildDropdown(
                _typeLogement,
                ['Appartement', 'Pavillon', 'Maison'],
                'Type logement',
                (v) => setState(() => _typeLogement = v ?? 'Appartement'),
              ),
              buildTextField(ctrlSurface, 'Surface (m²)', keyboardType: TextInputType.number),
              buildTextField(ctrlNbOccupants, 'Occupants', keyboardType: TextInputType.number),
              buildTextField(ctrlAnneeConst, 'Année construction', keyboardType: TextInputType.number),
              buildSwitch(_amiante, 'Repérage amiante', (v) => setState(() => _amiante = v)),
              buildSwitch(_accordCoProp, 'Accord Co-propriété', (v) => setState(() => _accordCoProp = v)),
              buildTextField(ctrlPieces, 'Pièces (ex: T4)'),
            ]),
            buildSection('Électricité DÉTAILLÉE (15 champs)', [
              buildDropdown(_electricite, ['EDF', 'Engie', 'Autre'], 'Fournisseur', (v) => setState(() => _electricite = v ?? 'EDF')),
              buildSwitch(_tableauConforme, 'Tableau conforme', (v) => setState(() => _tableauConforme = v)),
              buildTextField(ctrlCommentTGBT, 'Commentaire TGBT', maxLines: 2),
              buildTextField(ctrlDistTableau, 'Distance tableau (m)', keyboardType: TextInputType.number),
              buildTextField(ctrlPuissanceAbo, 'Puissance (kVA)', keyboardType: TextInputType.number),
              buildDropdown(
                _cheminement,
                ['Goulotte Int', 'Goulotte Ext'],
                'Cheminement',
                (v) => setState(() => _cheminement = v ?? 'Goulotte Int'),
              ),
              buildSwitch(_diff30ma, 'Différentiel 30mA', (v) => setState(() => _diff30ma = v)),
              buildTextField(ctrlTensionV, 'Tension (V)', keyboardType: TextInputType.number),
              buildTextField(ctrlEmplacements, 'Emplacements dispo', keyboardType: TextInputType.number),
              buildTextField(ctrlConsoAnnuelle, 'Conso annuelle (kWh)', keyboardType: TextInputType.number),
              buildTextField(ctrlCoutAnnuel, 'Coût annuel (€)', keyboardType: TextInputType.number),
              buildTextField(ctrlIntensiteA, 'Intensité (A)', keyboardType: TextInputType.number),
              buildDropdown(
                _typeRaccordement,
                ['Monophasé', 'Triphasé'],
                'Raccordement',
                (v) => setState(() => _typeRaccordement = v ?? 'Monophasé'),
              ),
              buildSwitch(_besoinTableauSupp, 'Tableau supplémentaire', (v) => setState(() => _besoinTableauSupp = v)),
              buildTextField(ctrlNbEmplacSupplt, 'Emplacements supp', keyboardType: TextInputType.number),
            ]),
            buildNavigationButtons(null, nextPage, false),
          ],
        ),
      ),
    );
  }

  /// PAGE 2: INSTALLATION GROUPES
  Widget _buildPage2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          buildPageHeader('Groupes Extérieur & Intérieur', Icons.ac_unit, Colors.teal),
          const SizedBox(height: 12),
          buildSection('Groupe Extérieur (8 champs)', [
            buildTextField(ctrlPieceGroupeExt, 'Pièce à laquelle s\'adosse'),
            buildSwitch(_groupeSurChaise, 'Sur chaise', (v) => setState(() => _groupeSurChaise = v)),
            buildTextField(ctrlDistObstacle, 'Distance obstacle (m)', keyboardType: TextInputType.number),
            buildTextField(ctrlHauteurFixation, 'Hauteur fixation (m)', keyboardType: TextInputType.number),
            buildDropdown(
              _typePompageExt,
              ['Oui', 'Non'],
              'Pompe relevage (ext)',
              (v) => setState(() => _typePompageExt = v ?? 'Non'),
            ),
            buildTextField(ctrlEvacCondensatsExt, 'Évac condensats (ext)'),
            buildSwitch(_groupeSurDalle, 'Sur dalle béton', (v) => setState(() => _groupeSurDalle = v)),
          ]),
          buildSection('Unité Intérieure (11 champs)', [
            buildTextField(ctrlPieceInt, 'Pièce de la maison'),
            buildDropdown(
              _typePompageInt,
              ['Oui', 'Non'],
              'Pompe relevage (int)',
              (v) => setState(() => _typePompageInt = v ?? 'Non'),
            ),
            buildTextField(ctrlEvacCondensatsInt, 'Évac condensats (int)'),
            buildTextField(ctrlSurfaceClim, 'Surface à climatiser (m²)', keyboardType: TextInputType.number),
            buildTextField(ctrlVolumeClim, 'Volume (m³)', keyboardType: TextInputType.number),
            buildTextField(ctrlEpaisseurMur, 'Épaisseur mur (cm)', keyboardType: TextInputType.number),
            buildTextField(ctrlLongRaccordement, 'Longueur raccordement', keyboardType: TextInputType.number),
            buildTextField(ctrlHauteurPieceClim, 'Hauteur pièce (m)', keyboardType: TextInputType.number),
            buildTextField(ctrlPuissanceUnite, 'Puissance unité (kW)', keyboardType: TextInputType.number),
            buildDropdown(
              _natureMurType,
              ['Parpaing', 'Brique', 'Pierre', 'Béton'],
              'Nature du mur',
              (v) => setState(() => _natureMurType = v ?? 'Parpaing'),
            ),
            buildTextField(ctrlDenivele, 'Denivele (m)', keyboardType: TextInputType.number),
          ]),
          buildNavigationButtons(previousPage, nextPage, false),
        ],
      ),
    );
  }

  /// PAGE 3: SOUHAIT + COMMENTAIRES + PHOTOS
  Widget _buildPage3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          buildPageHeader('Souhait & Photos', Icons.camera_alt, Colors.teal),
          const SizedBox(height: 12),
          buildPhotoRequirementAlert(),
          const SizedBox(height: 12),
          buildSection('Souhait Client', [
            buildSwitch(
              _financementSouhaite == 'Oui',
              'Offre financement',
              (v) => setState(() => _financementSouhaite = v ? 'Oui' : 'Non'),
            ),
            buildTextField(ctrlMarqueClient, 'Marque (souhait)'),
            buildTextField(ctrlModeleClient, 'Modèle (souhait)'),
          ]),
          buildSection('Commentaires', [
            buildTextField(ctrlCommentaire, 'Commentaire', maxLines: 3),
            buildTextField(ctrlInfoMagasin, 'Infos Magasinier', maxLines: 2),
            buildTextField(ctrlTravaux, 'Travaux client', maxLines: 2),
            buildTextField(ctrlTempCircuit, 'Température circuit'),
          ]),
          buildClimPhotosSection(),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _submitForm,
            icon: const Icon(Icons.save),
            label: const Text('ENREGISTRER LE RELEVÉ CLIM'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            ),
          ),
          const SizedBox(height: 20),
          buildNavigationButtons(previousPage, null, true),
        ],
      ),
    );
  }

  void _submitForm() {
    showSuccess('✅ Relevé Clim enregistré avec succès');
    saveFormData();
  }
}
