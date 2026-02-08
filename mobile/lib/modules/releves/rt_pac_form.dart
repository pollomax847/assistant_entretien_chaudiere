import 'package:flutter/material.dart';
import 'external_chauffage_expert/widgets/_photo_manager.dart';
import 'dart:io';
import 'package:assistant_entreiten_chaudiere/utils/mixins/form_field_builder_mixin.dart';
import 'package:assistant_entreiten_chaudiere/utils/mixins/form_state_mixin.dart';
import 'package:assistant_entreiten_chaudiere/utils/mixins/snackbar_mixin.dart';
import 'package:assistant_entreiten_chaudiere/utils/mixins/controller_dispose_mixin.dart';
import 'package:assistant_entreiten_chaudiere/utils/mixins/pagination_mixin.dart';
import 'package:assistant_entreiten_chaudiere/utils/mixins/photo_section_mixin.dart';
import 'package:assistant_entreiten_chaudiere/utils/mixins/animation_style_mixin.dart';
import 'models/photo_category.dart';
import 'widgets/single_photo_widget.dart';

/// Relevé Technique PAC - Formulaire complet 4 pages
/// 165 champs + 14 hydraulique + 8 dimensionnement + 4 photos
class RTPACForm extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>>? onSaved;

  const RTPACForm({super.key, this.onSaved});

  @override
  State<RTPACForm> createState() => _RTPACFormState();
}

class _RTPACFormState extends State<RTPACForm>
    with
        SingleTickerProviderStateMixin,
        AnimationStyleMixin,
        FormFieldBuilderMixin,
        FormStateMixin,
        SnackBarMixin,
        ControllerDisposeMixin,
        PaginationMixin,
        PhotoSectionMixin {
  final _formKey = GlobalKey<FormState>();
  late final AnimationController _introController = AnimationController(
    vsync: this,
    duration: entranceDuration,
  );

  // ===== CONTROLLERS PAGE 1 (Infos + Habitation) =====
  late TextEditingController ctrlNomClient;
  late TextEditingController ctrlAdresseFact;
  late TextEditingController ctrlEmail;
  late TextEditingController ctrlTelMobile;
  late TextEditingController ctrlRTName;
  late TextEditingController ctrlTechnicien;
  late TextEditingController ctrlAdresseInst;
  late TextEditingController ctrlDepartement;
  late TextEditingController ctrlAnneeConst;
  late TextEditingController ctrlSalledeBain;
  late TextEditingController ctrlSurfaceMenuiserie;
  late TextEditingController ctrlNbHabitants;
  late TextEditingController ctrlAltitude;
  late TextEditingController ctrlHauteurPiece;
  late TextEditingController ctrlSurfaceChauffer;
  late TextEditingController ctrlHauteurChauffer;
  late TextEditingController ctrlNbRadiateurs;

  // ===== CONTROLLERS PAGE 2 (Technique) =====
  late TextEditingController ctrlTempMaxConfort;
  late TextEditingController ctrlTempMinConfort;
  late TextEditingController ctrlTempCircuitPrim;
  late TextEditingController ctrlConsomFuel;
  late TextEditingController ctrlQtGazPropane;
  late TextEditingController ctrlDepartRetour;
  late TextEditingController ctrlMarqueEquip;
  late TextEditingController ctrlModeleEquip;
  late TextEditingController ctrlTensionV;
  late TextEditingController ctrlPuissanceAbo;
  late TextEditingController ctrlDistTableau;
  late TextEditingController ctrlEmplacements;
  late TextEditingController ctrlNbEmplacSupplt;
  late TextEditingController ctrlLargeurDalle;
  late TextEditingController ctrlNbCarottage;
  late TextEditingController ctrlLongueurDalle;
  late TextEditingController ctrlEpaisseurDalle;
  late TextEditingController ctrlHauteurDispoSousPlafond;
  late TextEditingController ctrlLargeurPortes;
  late TextEditingController ctrlLongueurSocle;
  late TextEditingController ctrlLongLiaisonFrigoriQ;
  late TextEditingController ctrlLongDalleInt;
  late TextEditingController ctrlEpaisseurDalleInt;

  // === CONTROLLERS HYDRAULIQUE (14 champs) ===
  late TextEditingController ctrlLongResHydra;
  late TextEditingController ctrlVolBallon;
  late TextEditingController ctrlVolGlycol;
  late TextEditingController ctrlDiamResHydra;
  late TextEditingController ctrlCapVaseExpansion;

  // ===== CONTROLLERS PAGE 3 (Dimensionnement + Photos) =====
  late TextEditingController ctrlTempExtBase;
  late TextEditingController ctrlPuissanceMinVisee;
  late TextEditingController ctrlPuissanceMaxVisee;
  late TextEditingController ctrlPuissanceMin7_55;
  late TextEditingController ctrlPuissanceMax7_55;
  late TextEditingController ctrlDeperditionTotale;
  late TextEditingController ctrlTauxCouverture;
  late TextEditingController ctrlMarqueClient;
  late TextEditingController ctrlModeleClient;
  late TextEditingController ctrlCommentaire;
  late TextEditingController ctrlInfoMagasin;
  late TextEditingController ctrlTravaux;
  // ===== PHOTOS =====
  List<PhotoData> _photos = [];

  // ===== STATES PAGE 1 =====
  String _typeLogement = 'Maison';
  bool _amiante = false;
  bool _amElioPlafonds = false;
  bool _energieFuel = false;
  bool _energieElec = true;
  bool _energieGN = false;
  bool _energieBois = false;
  bool _energiePropane = false;
  bool _amElioMurs = false;
  bool _amElioPlans = false;

  // ===== STATES PAGE 2 =====
  String _plancher = 'Terre-plein';
  String _typeVentilation = 'VMC double flux';
  String _usageECS = 'Douche';
  String _typeMenuiserie = 'PVC';
  String _config = 'Rectangulaire';
  String _typeConstruction = 'Monobloc';
  String _typeEmetteur1 = 'Radiateur fonte';
  String _typeEmetteur2 = 'Radiateur acier';
  String _typeGroupe = 'Split';
  String _cheminement = 'Goulotte Intérieure';
  String _electricite = 'EDF';

  bool _ecsIndependante = false;
  bool _neutralisationCuve = false;
  bool _instantanee = false;
  bool _accumulee = true;
  bool _ecsCoupleeChauf = true;
  bool _tableauConforme = true;
  bool _diff30ma = true;
  bool _besoinTableauSupp = false;
  bool _groupeSurDalle = true;
  bool _uiEmplacementChaud = true;

  // ===== STATES HYDRAULIQUE =====
  bool _vanne3Voies = true;
  bool _ballonDecouplage = true;
  bool _besoinVaseExpansion = true;
  bool _presenceGlycol = false;
  bool _presenceDisconnecteur = true;
  bool _vanne4Voies = false;
  bool _vanneMotorisee = false;
  bool _resHydraisolee = true;
  bool _vidangeExistante = false;

  // ===== STATES PAGE 3 =====
  String _financementSouhaite = 'Non';

  // ===== PHOTOS PAR SECTION =====
  File? _photoTGBT;
  File? _photoEtiquette;
  File? _photoTGBT2;
  File? _photoBallonTampon;
  File? _photoGroupeExterieur;
  File? _photoLiaisonsFrigo;
  File? _photoGroupeInterieur;
  File? _photoDisjoncteurDedie;

  @override
  void initState() {
    super.initState();
    _introController.forward();
    _initializeControllers();
    loadFormData();
  }

  void _initializeControllers() {
    // Page 1
    ctrlNomClient = registerController(TextEditingController());
    ctrlAdresseFact = registerController(TextEditingController());
    ctrlEmail = registerController(TextEditingController());
    ctrlTelMobile = registerController(TextEditingController());
    ctrlRTName = registerController(TextEditingController());
    ctrlTechnicien = registerController(TextEditingController());
    ctrlAdresseInst = registerController(TextEditingController());
    ctrlDepartement = registerController(TextEditingController());
    ctrlAnneeConst = registerController(TextEditingController());
    ctrlSalledeBain = registerController(TextEditingController());
    ctrlSurfaceMenuiserie = registerController(TextEditingController());
    ctrlNbHabitants = registerController(TextEditingController());
    ctrlAltitude = registerController(TextEditingController());
    ctrlHauteurPiece = registerController(TextEditingController());
    ctrlSurfaceChauffer = registerController(TextEditingController());
    ctrlHauteurChauffer = registerController(TextEditingController());
    ctrlNbRadiateurs = registerController(TextEditingController());

    // Page 2 - Technique
    ctrlTempMaxConfort = registerController(TextEditingController());
    ctrlTempMinConfort = registerController(TextEditingController());
    ctrlTempCircuitPrim = registerController(TextEditingController());
    ctrlConsomFuel = registerController(TextEditingController());
    ctrlQtGazPropane = registerController(TextEditingController());
    ctrlDepartRetour = registerController(TextEditingController());
    ctrlMarqueEquip = registerController(TextEditingController());
    ctrlModeleEquip = registerController(TextEditingController());
    ctrlTensionV = registerController(TextEditingController());
    ctrlPuissanceAbo = registerController(TextEditingController());
    ctrlDistTableau = registerController(TextEditingController());
    ctrlEmplacements = registerController(TextEditingController());
    ctrlNbEmplacSupplt = registerController(TextEditingController());
    ctrlLargeurDalle = registerController(TextEditingController());
    ctrlNbCarottage = registerController(TextEditingController());
    ctrlLongueurDalle = registerController(TextEditingController());
    ctrlEpaisseurDalle = registerController(TextEditingController());
    ctrlHauteurDispoSousPlafond = registerController(TextEditingController());
    ctrlLargeurPortes = registerController(TextEditingController());
    ctrlLongueurSocle = registerController(TextEditingController());
    ctrlLongLiaisonFrigoriQ = registerController(TextEditingController());
    ctrlLongDalleInt = registerController(TextEditingController());
    ctrlEpaisseurDalleInt = registerController(TextEditingController());

    // Hydraulique
    ctrlLongResHydra = registerController(TextEditingController());
    ctrlVolBallon = registerController(TextEditingController());
    ctrlVolGlycol = registerController(TextEditingController());
    ctrlDiamResHydra = registerController(TextEditingController());
    ctrlCapVaseExpansion = registerController(TextEditingController());

    // Page 3 - Dimensionnement
    ctrlTempExtBase = registerController(TextEditingController());
    ctrlPuissanceMinVisee = registerController(TextEditingController());
    ctrlPuissanceMaxVisee = registerController(TextEditingController());
    ctrlPuissanceMin7_55 = registerController(TextEditingController());
    ctrlPuissanceMax7_55 = registerController(TextEditingController());
    ctrlDeperditionTotale = registerController(TextEditingController());
    ctrlTauxCouverture = registerController(TextEditingController());
    ctrlMarqueClient = registerController(TextEditingController());
    ctrlModeleClient = registerController(TextEditingController());
    ctrlCommentaire = registerController(TextEditingController());
    ctrlInfoMagasin = registerController(TextEditingController());
    ctrlTravaux = registerController(TextEditingController());
  }

  @override
  void dispose() {
    _introController.dispose();
    disposeControllers();
    super.dispose();
  }

  void _setPage(int page) {
    setState(() => currentPage = page);
    _introController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relevé Technique PAC'),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: Column(
        children: [
          buildProgressBar(),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: _setPage,
              children: [
                buildFadeSlide(
                  fade: buildStaggeredFade(_introController, 0),
                  slide: buildStaggeredSlide(buildStaggeredFade(_introController, 0)),
                  child: _buildPage1(),
                ),
                buildFadeSlide(
                  fade: buildStaggeredFade(_introController, 0),
                  slide: buildStaggeredSlide(buildStaggeredFade(_introController, 0)),
                  child: _buildPage2(),
                ),
                buildFadeSlide(
                  fade: buildStaggeredFade(_introController, 0),
                  slide: buildStaggeredSlide(buildStaggeredFade(_introController, 0)),
                  child: _buildPage3(),
                ),
                buildFadeSlide(
                  fade: buildStaggeredFade(_introController, 0),
                  slide: buildStaggeredSlide(buildStaggeredFade(_introController, 0)),
                  child: _buildPage4(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// PAGE 1: INFOS + HABITATION
  Widget _buildPage1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            buildPageHeader('Infos & Habitation', Icons.house_siding, Colors.indigo),
            const SizedBox(height: 12),
            buildSection('Client (6 champs)', [
              buildTextField(ctrlNomClient, 'Nom du client'),
              buildTextField(ctrlAdresseFact, 'Adresse de facturation', maxLines: 2),
              buildTextField(ctrlEmail, 'Email', keyboardType: TextInputType.emailAddress),
              buildTextField(ctrlTelMobile, 'Téléphone mobile', keyboardType: TextInputType.phone),
            ]),
            buildSection('Informations Générales', [
              buildTextField(ctrlRTName, 'Nom RT'),
              buildTextField(ctrlTechnicien, 'Technicien'),
              buildTextField(ctrlAdresseInst, 'Adresse installation', maxLines: 2),
            ]),
            const SizedBox(height: 16),
            SinglePhotoWidget(
              category: PhotoCategoriesByType.forPAC()[0],
              initialPhoto: _photoTGBT,
              onPhotoChanged: (file) => setState(() => _photoTGBT = file),
            ),
            const SizedBox(height: 16),
            SinglePhotoWidget(
              category: PhotoCategoriesByType.forPAC()[1],
              initialPhoto: _photoEtiquette,
              onPhotoChanged: (file) => setState(() => _photoEtiquette = file),
            ),
            const SizedBox(height: 16),
            buildSection('Habitation (24 champs)', [
              buildDropdown(_typeLogement, ['Maison', 'Appartement'], 'Type', (v) => setState(() => _typeLogement = v ?? 'Maison')),
              buildTextField(ctrlDepartement, 'Département'),
              buildTextField(ctrlAnneeConst, 'Année construction', keyboardType: TextInputType.number),
              buildSwitch(_amiante, 'Repérage amiante', (v) => setState(() => _amiante = v)),
              buildTextField(ctrlSalledeBain, 'Salles de bain', keyboardType: TextInputType.number),
              buildDropdown(_plancher, ['Terre-plein', 'Vide sanitaire', 'Sous-sol'], 'Plancher bas', (v) => setState(() => _plancher = v ?? 'Terre-plein')),
              buildSwitch(_amElioPlafonds, 'Amélioration plafonds', (v) => setState(() => _amElioPlafonds = v)),
              buildTextField(ctrlSurfaceMenuiserie, 'Surface menuiserie (m²)', keyboardType: TextInputType.number),
              buildDropdown(_typeVentilation, ['VMC simple flux', 'VMC double flux', 'Naturelle'], 'Ventilation', (v) => setState(() => _typeVentilation = v ?? 'VMC double flux')),
              buildSwitch(_energieFuel, 'Énergie Fuel', (v) => setState(() => _energieFuel = v)),
              buildSwitch(_energieElec, 'Énergie Électrique', (v) => setState(() => _energieElec = v)),
              buildTextField(ctrlNbHabitants, 'Habitants', keyboardType: TextInputType.number),
              buildTextField(ctrlAltitude, 'Altitude (m)', keyboardType: TextInputType.number),
              buildDropdown(_config, ['Rectangulaire', 'Carrée', 'Complexe'], 'Configuration', (v) => setState(() => _config = v ?? 'Rectangulaire')),
              buildDropdown(_typeConstruction, ['Monobloc', 'Étages'], 'Niveaux', (v) => setState(() => _typeConstruction = v ?? 'Monobloc')),
              buildDropdown(_usageECS, ['Douche', 'Bain'], 'Usage ECS', (v) => setState(() => _usageECS = v ?? 'Douche')),
              buildSwitch(_amElioMurs, 'Amélioration murs', (v) => setState(() => _amElioMurs = v)),
              buildSwitch(_amElioPlans, 'Amélioration planchers', (v) => setState(() => _amElioPlans = v)),
              buildDropdown(_typeMenuiserie, ['Bois', 'PVC', 'Alu'], 'Menuiserie', (v) => setState(() => _typeMenuiserie = v ?? 'PVC')),
              buildTextField(ctrlHauteurPiece, 'Hauteur pièce (m)', keyboardType: TextInputType.number),
              buildSwitch(_energieGN, 'Énergie GN', (v) => setState(() => _energieGN = v)),
              buildSwitch(_energieBois, 'Énergie Bois', (v) => setState(() => _energieBois = v)),
              buildSwitch(_energiePropane, 'Énergie Propane', (v) => setState(() => _energiePropane = v)),
            ]),
            buildNavigationButtons(null, nextPage, false),
          ],
        ),
      ),
    );
  }

  /// PAGE 2: TECHNIQUE + HYDRAULIQUE
  Widget _buildPage2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          buildPageHeader('Thermique & Hydraulique', Icons.water_drop, Colors.indigo),
          const SizedBox(height: 12),
          buildSection('Volumes & Émetteurs (5 champs)', [
            buildTextField(ctrlSurfaceChauffer, 'Surface à chauffer (m²)', keyboardType: TextInputType.number),
            buildTextField(ctrlHauteurChauffer, 'Hauteur à chauffer (m)', keyboardType: TextInputType.number),
            buildDropdown(_typeEmetteur1, ['Radiateur fonte', 'Radiateur acier', 'Plancher chauffant'], 'Émetteur zone 1', (v) => setState(() => _typeEmetteur1 = v ?? 'Radiateur fonte')),
            buildDropdown(_typeEmetteur2, ['Radiateur fonte', 'Radiateur acier', 'Plancher chauffant'], 'Émetteur zone 2', (v) => setState(() => _typeEmetteur2 = v ?? 'Radiateur acier')),
            buildTextField(ctrlNbRadiateurs, 'Nombre radiateurs', keyboardType: TextInputType.number),
          ]),
          buildSection('Appareil & Régulation (16 champs)', [
            buildTextField(ctrlTempMaxConfort, 'Temp. max confort (°C)', keyboardType: TextInputType.number),
            buildTextField(ctrlTempMinConfort, 'Temp. min confort (°C)', keyboardType: TextInputType.number),
            buildTextField(ctrlTempCircuitPrim, 'Temp. circuit primaire (°C)', keyboardType: TextInputType.number),
            buildSwitch(_ecsIndependante, 'ECS indépendante', (v) => setState(() => _ecsIndependante = v)),
            buildTextField(ctrlConsomFuel, 'Consommation Fuel (L)', keyboardType: TextInputType.number),
            buildSwitch(_neutralisationCuve, 'Neutralisation cuve', (v) => setState(() => _neutralisationCuve = v)),
            buildTextField(ctrlDepartRetour, 'Départ/retour chauffage (mm)', keyboardType: TextInputType.number),
            buildSwitch(_instantanee, 'Instantanée', (v) => setState(() => _instantanee = v)),
            buildSwitch(_accumulee, 'Accumulée', (v) => setState(() => _accumulee = v)),
            buildTextField(ctrlQtGazPropane, 'Quantité gaz propane (tonne)', keyboardType: TextInputType.number),
            buildTextField(ctrlMarqueEquip, 'Marque équipement'),
            buildTextField(ctrlModeleEquip, 'Modèle équipement'),
            buildSwitch(_ecsCoupleeChauf, 'ECS couplée chauffage', (v) => setState(() => _ecsCoupleeChauf = v)),
          ]),
          buildSection('Hydraulique CRUCIAL (14 champs)', [
            buildSwitch(_vanne3Voies, 'Vanne 3 voies', (v) => setState(() => _vanne3Voies = v)),
            buildSwitch(_ballonDecouplage, 'Ballon découplage/tampon', (v) => setState(() => _ballonDecouplage = v)),
            buildTextField(ctrlLongResHydra, 'Longueur réseau à isoler (m)', keyboardType: TextInputType.number),
            buildSwitch(_besoinVaseExpansion, 'Besoin vase expansion', (v) => setState(() => _besoinVaseExpansion = v)),
            buildSwitch(_presenceGlycol, 'Présence glycol', (v) => setState(() => _presenceGlycol = v)),
            buildTextField(ctrlVolBallon, 'Volume ballon découplage (L)', keyboardType: TextInputType.number),
            buildSwitch(_presenceDisconnecteur, 'Présence disconnecteur', (v) => setState(() => _presenceDisconnecteur = v)),
            buildTextField(ctrlVolGlycol, 'Volume glycol (L)', keyboardType: TextInputType.number),
            buildSwitch(_vanne4Voies, 'Vanne 4 voies', (v) => setState(() => _vanne4Voies = v)),
            buildSwitch(_vanneMotorisee, 'Vanne motorisée', (v) => setState(() => _vanneMotorisee = v)),
            buildSwitch(_resHydraisolee, 'Réseau hydraulique isolé', (v) => setState(() => _resHydraisolee = v)),
            buildTextField(ctrlDiamResHydra, 'Diamètre réseau (mm)', keyboardType: TextInputType.number),
            buildTextField(ctrlCapVaseExpansion, 'Capacité vase expansion (L)', keyboardType: TextInputType.number),
            buildSwitch(_vidangeExistante, 'Vidange existante', (v) => setState(() => _vidangeExistante = v)),
          ]),
          const SizedBox(height: 16),
          SinglePhotoWidget(
            category: PhotoCategoriesByType.forPAC()[2],
            initialPhoto: _photoTGBT2,
            onPhotoChanged: (file) => setState(() => _photoTGBT2 = file),
          ),
          const SizedBox(height: 16),
          SinglePhotoWidget(
            category: PhotoCategoriesByType.forPAC()[3],
            initialPhoto: _photoBallonTampon,
            onPhotoChanged: (file) => setState(() => _photoBallonTampon = file),
          ),
          const SizedBox(height: 16),
          buildNavigationButtons(previousPage, nextPage, false),
        ],
      ),
    );
  }

  /// PAGE 3: ÉLECTRICITÉ + GROUPES + DIMENSIONNEMENT + PHOTOS
  Widget _buildPage3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          buildPageHeader('Installation & Dimensionnement', Icons.settings, Colors.indigo),
          const SizedBox(height: 12),
          buildSection('Électricité (13 champs)', [
            buildSwitch(_tableauConforme, 'Tableau conforme', (v) => setState(() => _tableauConforme = v)),
            buildSwitch(_diff30ma, 'Différentiel 30mA', (v) => setState(() => _diff30ma = v)),
            buildTextField(ctrlNbEmplacSupplt, 'Emplacements supplémentaires', keyboardType: TextInputType.number),
            buildTextField(ctrlTensionV, 'Tension (V)', keyboardType: TextInputType.number),
            buildTextField(ctrlPuissanceAbo, 'Puissance abonnement (kVA)', keyboardType: TextInputType.number),
            buildDropdown(_electricite, ['EDF', 'Engie', 'Autre'], 'Électricité', (v) => setState(() => _electricite = v ?? 'EDF')),
            buildSwitch(_besoinTableauSupp, 'Besoin tableau supplémentaire', (v) => setState(() => _besoinTableauSupp = v)),
            buildTextField(ctrlDistTableau, 'Distance tableau (m)', keyboardType: TextInputType.number),
            buildTextField(ctrlEmplacements, 'Emplacements disponibles', keyboardType: TextInputType.number),
            buildDropdown(_cheminement, ['Goulotte Intérieure', 'Goulotte Extérieure'], 'Cheminement', (v) => setState(() => _cheminement = v ?? 'Goulotte Intérieure')),
          ]),
          buildSection('Groupe Extérieur (6 champs)', [
            buildSwitch(_groupeSurDalle, 'Groupe sur dalle béton', (v) => setState(() => _groupeSurDalle = v)),
            buildTextField(ctrlLargeurDalle, 'Largeur dalle (cm)', keyboardType: TextInputType.number),
            buildDropdown(_typeGroupe, ['Split', 'Monobloc'], 'Type groupe', (v) => setState(() => _typeGroupe = v ?? 'Split')),
            buildTextField(ctrlNbCarottage, 'Nombre carottage', keyboardType: TextInputType.number),
            buildTextField(ctrlLongueurDalle, 'Longueur dalle (cm)', keyboardType: TextInputType.number),
            buildTextField(ctrlEpaisseurDalle, 'Épaisseur dalle (cm)', keyboardType: TextInputType.number),
          ]),
          const SizedBox(height: 16),
          SinglePhotoWidget(
            category: PhotoCategoriesByType.forPAC()[4],
            initialPhoto: _photoGroupeExterieur,
            onPhotoChanged: (file) => setState(() => _photoGroupeExterieur = file),
          ),
          const SizedBox(height: 16),
          SinglePhotoWidget(
            category: PhotoCategoriesByType.forPAC()[5],
            initialPhoto: _photoLiaisonsFrigo,
            onPhotoChanged: (file) => setState(() => _photoLiaisonsFrigo = file),
          ),
          const SizedBox(height: 16),
          buildSection('Unité Intérieure (7 champs)', [
            buildTextField(ctrlHauteurDispoSousPlafond, 'Hauteur sous plafond (m)', keyboardType: TextInputType.number),
            buildTextField(ctrlLargeurPortes, 'Largeur portes accès', keyboardType: TextInputType.number),
            buildTextField(ctrlLongueurSocle, 'Longueur socle (cm)', keyboardType: TextInputType.number),
            buildTextField(ctrlLongLiaisonFrigoriQ, 'Longueur liaison frigorifique', keyboardType: TextInputType.number),
            buildSwitch(_uiEmplacementChaud, 'UI emplacement chaudière', (v) => setState(() => _uiEmplacementChaud = v)),
            buildTextField(ctrlLongDalleInt, 'Longueur dalle int (cm)', keyboardType: TextInputType.number),
            buildTextField(ctrlEpaisseurDalleInt, 'Épaisseur dalle int (cm)', keyboardType: TextInputType.number),
          ]),
          const SizedBox(height: 16),
          SinglePhotoWidget(
            category: PhotoCategoriesByType.forPAC()[6],
            initialPhoto: _photoGroupeInterieur,
            onPhotoChanged: (file) => setState(() => _photoGroupeInterieur = file),
          ),
          const SizedBox(height: 16),
          buildSection('Dimensionnement Thermique CRITIQUE (8 champs)', [
            buildTextField(ctrlTempExtBase, 'Temp. ext. base (°C)', keyboardType: TextInputType.number),
            buildTextField(ctrlPuissanceMinVisee, 'Puissance min visée (kW)', keyboardType: TextInputType.number),
            buildTextField(ctrlPuissanceMaxVisee, 'Puissance max visée (kW)', keyboardType: TextInputType.number),
            buildTextField(ctrlPuissanceMin7_55, 'Puissance min à -7/+55°C (kW)', keyboardType: TextInputType.number),
            buildTextField(ctrlPuissanceMax7_55, 'Puissance max à -7/+55°C (kW)', keyboardType: TextInputType.number),
            buildTextField(ctrlDeperditionTotale, 'Déperdition totale (kW)', keyboardType: TextInputType.number),
            buildTextField(ctrlTauxCouverture, 'Taux de couverture (%)', keyboardType: TextInputType.number),
          ]),
          const SizedBox(height: 16),
          SinglePhotoWidget(
            category: PhotoCategoriesByType.forPAC()[7],
            initialPhoto: _photoDisjoncteurDedie,
            onPhotoChanged: (file) => setState(() => _photoDisjoncteurDedie = file),
          ),
          const SizedBox(height: 16),
          buildSection('Souhait Client', [
            buildSwitch(
              _financementSouhaite == 'Oui',
              'Offre financement souhaitée',
              (v) => setState(() => _financementSouhaite = v ? 'Oui' : 'Non'),
            ),
            buildTextField(ctrlMarqueClient, 'Marque (souhait)'),
            buildTextField(ctrlModeleClient, 'Modèle (souhait)'),
          ]),
          buildSection('Commentaires', [
            buildTextField(ctrlCommentaire, 'Commentaire', maxLines: 3),
            buildTextField(ctrlInfoMagasin, 'Infos Magasinier', maxLines: 2),
            buildTextField(ctrlTravaux, 'Travaux client', maxLines: 2),
          ]),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _submitForm,
            icon: const Icon(Icons.save),
            label: const Text('ENREGISTRER LE RELEVÉ PAC'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            ),
          ),
          const SizedBox(height: 20),
          buildNavigationButtons(previousPage, () {
            final data = {
              'type': 'pac',
              'client': {
                'nom': ctrlNomClient.text,
                'adresse': ctrlAdresseFact.text,
              },
              'marque': ctrlMarqueEquip.text,
              'modele': ctrlModeleEquip.text,
              'commentaire': ctrlCommentaire.text,
            };
            if (widget.onSaved != null) widget.onSaved!(data);
          }, true),
        ],
      ),
    );
  }

  /// PAGE 4: PHOTOS
  Widget _buildPage4() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          buildPageHeader('Photos du relevé PAC', Icons.photo_camera, Colors.purple),
          const SizedBox(height: 16),
          PhotoManager(
            photos: _photos,
            onPhotosChanged: (photos) {
              setState(() => _photos = photos);
            },
            clientId: 'test-client',
            typeReleve: 'pac',
          ),
          const SizedBox(height: 20),
          buildNavigationButtons(previousPage, () {
            final data = {
              'type': 'pac',
              'photos': _photos.map((p) => p.toMap()).toList(),
            };
            if (widget.onSaved != null) widget.onSaved!(data);
          }, true),
        ],
      ),
    );
  }

  void _submitForm() {
    showSuccess('✅ Relevé PAC enregistré avec succès');
    saveFormData();
  }
}
