import 'package:flutter/material.dart';
import 'dart:io';
import 'package:assistant_entreiten_chaudiere/utils/mixins/form_field_builder_mixin.dart';
import 'package:assistant_entreiten_chaudiere/utils/mixins/form_state_mixin.dart';
import 'package:assistant_entreiten_chaudiere/utils/mixins/snackbar_mixin.dart';
import 'package:assistant_entreiten_chaudiere/utils/mixins/controller_dispose_mixin.dart';
import 'package:assistant_entreiten_chaudiere/utils/mixins/pagination_mixin.dart';
import 'package:assistant_entreiten_chaudiere/utils/mixins/photo_section_mixin.dart';
import 'package:assistant_entreiten_chaudiere/utils/mixins/conformity_checklist_mixin.dart';
import 'models/photo_category.dart';
import 'widgets/single_photo_widget.dart';

/// Relevé Technique Chaudière - Formulaire complet 3 pages
/// 152 champs + 22 conformité + 3 photos
class RTChaudiereForm extends StatefulWidget {
  const RTChaudiereForm({super.key});

  @override
  State<RTChaudiereForm> createState() => _RTChaudiereFormState();
}

class _RTChaudiereFormState extends State<RTChaudiereForm>
    with
        FormFieldBuilderMixin,
        FormStateMixin,
        SnackBarMixin,
        ControllerDisposeMixin,
        PaginationMixin,
        PhotoSectionMixin,
        ConformityChecklistMixin {
  final _formKey = GlobalKey<FormState>();

  // ===== CONTROLLERS PAGE 1 =====
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
  late TextEditingController ctrlMarqueActuelle;
  late TextEditingController ctrlAnneeChaudiere;
  late TextEditingController ctrlLitres;
  late TextEditingController ctrlHauteur;
  late TextEditingController ctrlProfondeur;
  late TextEditingController ctrlTuyauterie;

  // ===== CONTROLLERS PAGE 2 =====
  late TextEditingController ctrlDiamEaux;
  late TextEditingController ctrlDistChaudiere;
  late TextEditingController ctrlLongEaux;
  late TextEditingController ctrlPuissance;
  late TextEditingController ctrlLargeur;
  late TextEditingController ctrlDiamConduitFumee;
  late TextEditingController ctrlNbCoudesConduit;
  late TextEditingController ctrlLongTubageFumee;
  late TextEditingController ctrlLongConduitShunt;
  late TextEditingController ctrlDiamConduitVMC;
  late TextEditingController ctrlNbCoudesVMC;
  late TextEditingController ctrlDiamBoucheVMC;
  late TextEditingController ctrlLongConduitFumee;
  late TextEditingController ctrlDiamTubageFumee;
  late TextEditingController ctrlDiamConduitShunt;
  late TextEditingController ctrlNbCoudesShunt;
  late TextEditingController ctrlLongConduitVMC;
  late TextEditingController ctrlDiamBouchonVMC;

  // ===== CONTROLLERS PAGE 3 =====
  late TextEditingController ctrlMarqueClient;
  late TextEditingController ctrlModeleClient;
  late TextEditingController ctrlCommentaire;
  late TextEditingController ctrlInfoMagasin;
  late TextEditingController ctrlTravaux;
  late TextEditingController ctrlTempCircuit;

  // ===== STATES PAGE 1 =====
  String _typeLogement = 'Appartement';
  bool _amiante = false;
  bool _accordCoProp = false;
  bool _chauffageSeul = false;
  bool _mixteInstantanee = true;
  bool _avecBallon = false;
  bool _radiateur = true;
  bool _tuyauxArriere = false;

  // ===== STATES PAGE 2 =====
  String _typeAppareil = 'Chaudière';
  String _typeEnergie = 'GN';
  String _typeFonction = 'ECS instantanée';
  String _typeConduitFumee = 'Conduit fumée';
  bool _conduitFumeeRigide = true;
  bool _conduitShuntRigide = false;
  bool _conduitVMCRigide = false;
  bool _shunt = false;

  // Conformité (22 points)
  final Map<String, bool> _conformityAnswers = {};

  // ===== STATES PAGE 3 =====
  String _financementSouhaite = 'Non';

  // ===== PHOTOS PAR SECTION =====
  File? _photoPlaque;
  File? _photoEtiquette;
  File? _photoCompteurGaz;
  File? _photoVueExterieure;
  File? _photoEvacuationFumees;
  File? _photoVaseExpansion;
  File? _photoVueEloignee;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    loadFormData();
  }

  void _initializeControllers() {
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
    ctrlMarqueActuelle = registerController(TextEditingController());
    ctrlAnneeChaudiere = registerController(TextEditingController());
    ctrlLitres = registerController(TextEditingController());
    ctrlHauteur = registerController(TextEditingController());
    ctrlProfondeur = registerController(TextEditingController());
    ctrlTuyauterie = registerController(TextEditingController());
    ctrlDiamEaux = registerController(TextEditingController());
    ctrlDistChaudiere = registerController(TextEditingController());
    ctrlLongEaux = registerController(TextEditingController());
    ctrlPuissance = registerController(TextEditingController());
    ctrlLargeur = registerController(TextEditingController());
    ctrlMarqueClient = registerController(TextEditingController());
    ctrlModeleClient = registerController(TextEditingController());
    ctrlCommentaire = registerController(TextEditingController());
    ctrlInfoMagasin = registerController(TextEditingController());
    ctrlTravaux = registerController(TextEditingController());
    ctrlTempCircuit = registerController(TextEditingController());
    ctrlDiamConduitFumee = registerController(TextEditingController());
    ctrlNbCoudesConduit = registerController(TextEditingController());
    ctrlLongTubageFumee = registerController(TextEditingController());
    ctrlLongConduitShunt = registerController(TextEditingController());
    ctrlDiamConduitVMC = registerController(TextEditingController());
    ctrlNbCoudesVMC = registerController(TextEditingController());
    ctrlDiamBoucheVMC = registerController(TextEditingController());
    ctrlLongConduitFumee = registerController(TextEditingController());
    ctrlDiamTubageFumee = registerController(TextEditingController());
    ctrlDiamConduitShunt = registerController(TextEditingController());
    ctrlNbCoudesShunt = registerController(TextEditingController());
    ctrlLongConduitVMC = registerController(TextEditingController());
    ctrlDiamBouchonVMC = registerController(TextEditingController());
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
        title: const Text('Relevé Technique Chaudière'),
        backgroundColor: Colors.blue,
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

  /// PAGE 1: INFOS CLIENT + ENVIRONNEMENT
  Widget _buildPage1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            buildPageHeader('Infos Client & Environnement', Icons.business, Colors.blue),
            const SizedBox(height: 12),
            buildSection('Client (6 champs)', [
              buildTextField(ctrlNomClient, 'Nom du client'),
              buildTextField(ctrlAdresseFact, 'Adresse de facturation', maxLines: 2),
              buildTextField(ctrlEmail, 'Email', keyboardType: TextInputType.emailAddress),
              buildTextField(ctrlTelFixe, 'Téléphone fixe', keyboardType: TextInputType.phone),
              buildTextField(ctrlTelMobile, 'Téléphone mobile', keyboardType: TextInputType.phone),
            ]),
            buildSection('Informations Générales', [
              buildTextField(ctrlRTName, 'Nom du Relevé Technique'),
              buildTextField(ctrlTechnicien, 'Nom du technicien'),
              buildTextField(ctrlAdresseInst, 'Adresse d\'installation', maxLines: 2),
            ]),
            const SizedBox(height: 16),
            SinglePhotoWidget(
              category: PhotoCategoriesByType.forChaudiere()[2],
              initialPhoto: _photoCompteurGaz,
              onPhotoChanged: (file) => setState(() => _photoCompteurGaz = file),
            ),
            const SizedBox(height: 16),
            buildSection('Environnement (7 champs)', [
              buildDropdown(
                _typeLogement,
                ['Appartement', 'Pavillon', 'Maison'],
                'Type de logement',
                (val) => setState(() => _typeLogement = val ?? 'Appartement'),
              ),
              buildTextField(ctrlSurface, 'Surface (m²)', keyboardType: TextInputType.number),
              buildTextField(ctrlNbOccupants, 'Nombre d\'occupants', keyboardType: TextInputType.number),
              buildTextField(ctrlAnneeConst, 'Année de construction', keyboardType: TextInputType.number),
              buildTextField(ctrlPieces, 'Nombre de pièces (ex: T3)'),
              buildSwitch(_amiante, 'Repérage amiante établi', (val) => setState(() => _amiante = val)),
              buildSwitch(_accordCoProp, 'Accord Co-propriété', (val) => setState(() => _accordCoProp = val)),
            ]),
            buildSection('Équipement en Place (13 champs)', [
              buildTextField(ctrlMarqueActuelle, 'Marque'),
              buildTextField(ctrlAnneeChaudiere, 'Année', keyboardType: TextInputType.number),
              buildSwitch(_chauffageSeul, 'Chauffage seul', (val) => setState(() => _chauffageSeul = val)),
              buildSwitch(_mixteInstantanee, 'Mixte instantanée', (val) => setState(() => _mixteInstantanee = val)),
              buildSwitch(_avecBallon, 'Avec ballon', (val) => setState(() => _avecBallon = val)),
              if (_avecBallon) ...[
                buildTextField(ctrlLitres, 'Volume ballon (L)', keyboardType: TextInputType.number),
                buildTextField(ctrlHauteur, 'Hauteur (cm)', keyboardType: TextInputType.number),
                buildTextField(ctrlProfondeur, 'Profondeur (cm)', keyboardType: TextInputType.number),
              ],
              buildSwitch(_radiateur, 'Radiateur', (val) => setState(() => _radiateur = val)),
              buildTextField(ctrlTuyauterie, 'Type de tuyauterie'),
              buildSwitch(_tuyauxArriere, 'Tuyaux derrière chaudière', (val) => setState(() => _tuyauxArriere = val)),
            ]),
            const SizedBox(height: 16),
            SinglePhotoWidget(
              category: PhotoCategoriesByType.forChaudiere()[1],
              initialPhoto: _photoEtiquette,
              onPhotoChanged: (file) => setState(() => _photoEtiquette = file),
            ),
            const SizedBox(height: 12),
            SinglePhotoWidget(
              category: PhotoCategoriesByType.forChaudiere()[0],
              initialPhoto: _photoPlaque,
              onPhotoChanged: (file) => setState(() => _photoPlaque = file),
            ),
            buildNavigationButtons(null, nextPage, false),
          ],
        ),
      ),
    );
  }

  /// PAGE 2: TECHNIQUE CHAUDIÈRE
  Widget _buildPage2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          buildPageHeader('Technique & Conformité', Icons.settings, Colors.blue),
          const SizedBox(height: 12),
          buildSection('Type/Énergie/Fonction', [
            buildDropdown(
              _typeAppareil,
              ['Chaudière', 'VMC', 'ESC', 'Adoucisseur', 'Radiateur'],
              'Type d\'appareil',
              (val) => setState(() => _typeAppareil = val ?? 'Chaudière'),
            ),
            buildDropdown(
              _typeEnergie,
              ['GN (Gaz naturel)', 'GPL (Propane)', 'FOD (Fioul)'],
              'Type d\'énergie',
              (val) => setState(() => _typeEnergie = val ?? 'GN'),
            ),
            buildDropdown(
              _typeFonction,
              ['ECS instantanée', 'Chauffage seul', 'Ballon séparé', 'Accu', 'Micro accu'],
              'Fonction',
              (val) => setState(() => _typeFonction = val ?? 'ECS instantanée'),
            ),
          ]),
          buildSection('Évacuation Fumées (17 champs)', [
            buildDropdown(
              _typeConduitFumee,
              ['Conduit fumée', 'Conduit Shunt', 'Conduit VMC', 'Ventouse'],
              'Type de conduit',
              (val) => setState(() => _typeConduitFumee = val ?? 'Conduit fumée'),
            ),
            buildTextField(ctrlDiamConduitFumee, 'Diamètre conduit fumée (mm)', keyboardType: TextInputType.number),
            buildTextField(ctrlNbCoudesConduit, 'Nombre de coudes 90°', keyboardType: TextInputType.number),
            buildTextField(ctrlLongTubageFumee, 'Longueur tubage (m)', keyboardType: TextInputType.number),
            buildTextField(ctrlLongConduitShunt, 'Longueur conduit shunt (m)', keyboardType: TextInputType.number),
            buildTextField(ctrlDiamConduitVMC, 'Diamètre conduit VMC (mm)', keyboardType: TextInputType.number),
            buildTextField(ctrlNbCoudesVMC, 'Nombre coudes VMC', keyboardType: TextInputType.number),
            buildSwitch(_conduitFumeeRigide, 'Conduit fumée rigide', (val) => setState(() => _conduitFumeeRigide = val)),
            buildSwitch(_conduitShuntRigide, 'Conduit Shunt rigide', (val) => setState(() => _conduitShuntRigide = val)),
            buildSwitch(_conduitVMCRigide, 'Conduit VMC rigide', (val) => setState(() => _conduitVMCRigide = val)),
            buildSwitch(_shunt, 'Shunt présent', (val) => setState(() => _shunt = val)),
            buildTextField(ctrlDiamBoucheVMC, 'Diamètre bouche VMC (mm)', keyboardType: TextInputType.number),
            buildTextField(ctrlLongConduitFumee, 'Longueur conduit fumée (m)', keyboardType: TextInputType.number),
            buildTextField(ctrlDiamTubageFumee, 'Diamètre tubage (m)', keyboardType: TextInputType.number),
          ]),
          const SizedBox(height: 16),
          SinglePhotoWidget(
            category: PhotoCategoriesByType.forChaudiere()[4],
            initialPhoto: _photoEvacuationFumees,
            onPhotoChanged: (file) => setState(() => _photoEvacuationFumees = file),
          ),
          const SizedBox(height: 16),
          buildConformitySection(_conformityAnswers, (id, val) => setState(() => _conformityAnswers[id] = val)),
          const SizedBox(height: 16),
          SinglePhotoWidget(
            category: PhotoCategoriesByType.forChaudiere()[5],
            initialPhoto: _photoVaseExpansion,
            onPhotoChanged: (file) => setState(() => _photoVaseExpansion = file),
          ),
          const SizedBox(height: 12),
          SinglePhotoWidget(
            category: PhotoCategoriesByType.forChaudiere()[3],
            initialPhoto: _photoVueExterieure,
            onPhotoChanged: (file) => setState(() => _photoVueExterieure = file),
          ),
          const SizedBox(height: 20),
          buildNavigationButtons(previousPage, nextPage, false),
        ],
      ),
    );
  }

  /// PAGE 3: RÉSUMÉ + PHOTOS
  Widget _buildPage3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          buildPageHeader('Résumé & Photos', Icons.photo_camera, Colors.blue),
          const SizedBox(height: 12),
          buildPhotoRequirementAlert(),
          const SizedBox(height: 12),
          SinglePhotoWidget(
            category: PhotoCategoriesByType.forChaudiere()[6],
            initialPhoto: _photoVueEloignee,
            onPhotoChanged: (file) => setState(() => _photoVueEloignee = file),
          ),
          const SizedBox(height: 12),
          buildSection('Souhait Client', [
            buildSwitch(
              _financementSouhaite == 'Oui',
              'Offre de financement souhaitée',
              (val) => setState(() => _financementSouhaite = val ? 'Oui' : 'Non'),
            ),
            buildTextField(ctrlMarqueClient, 'Marque (souhait)'),
            buildTextField(ctrlModeleClient, 'Modèle (souhait)'),
          ]),
          buildSection('Commentaires', [
            buildTextField(ctrlCommentaire, 'Commentaire général', maxLines: 3),
            buildTextField(ctrlInfoMagasin, 'Infos Magasinier', maxLines: 2),
            buildTextField(ctrlTravaux, 'Travaux à charge client', maxLines: 2),
            buildTextField(ctrlTempCircuit, 'Température circuit primaire'),
          ]),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _submitForm,
            icon: const Icon(Icons.save),
            label: const Text('ENREGISTRER LE RELEVÉ CHAUDIÈRE'),
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
    showSuccess('✅ Relevé Chaudière enregistré avec succès');
    saveFormData();
  }
}
