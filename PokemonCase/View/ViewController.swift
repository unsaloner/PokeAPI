//
//  ViewController.swift
//  PokemonCase
//
//  Created by Unsal Oner on 22.03.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collection: UICollectionView!
    
    var viewModel = ViewModel()
    
    var pokemonList = [ViewListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        
        getData()
        
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collection.register(nib, forCellWithReuseIdentifier: "cell")
        
        
       
    }

    
    func getData(){
        viewModel.fetchPokemons { poke in
            if let poke = poke {
                self.pokemonList = (poke.results.map({ViewListModel(pokemons: $0)}))
                DispatchQueue.main.async {
                    self.collection.reloadData()
                }
            }
        }
    }
    
    
    // UIAlertController kullanarak pop-up göstermek için bir fonksiyon
    func showPokemonAbilitiesAlert(abilities: [String]) {
        let alert = UIAlertController(title: "Abilities", message: abilities.joined(separator: ", "), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    
        
    }
//MARK: CollectionView Delegate & DataSource
extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     return pokemonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let pokemon = pokemonList[indexPath.row]
        
        cell.nameLabel.text = pokemon.pokeName
        
        viewModel.downloadPokemonImage(pokemonID: indexPath.row+1) { imageList in
            if let imageList = imageList {
                if let imageUrl = URL(string: imageList.imageUrl) {
                    URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                        guard let imageData = data, error == nil else {
                            return
                        }
                        DispatchQueue.main.async {
                            if let image = UIImage(data: imageData),
                               let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
                                cell.imageView.image = image
                            }
                        }
                    }.resume()
                }
            }
        }
   
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.fetchPokemonAbilities(pokemonId: indexPath.row + 1) { abilities in
            DispatchQueue.main.async {
                self.showPokemonAbilitiesAlert(abilities: abilities)
            }
        }
    }
    
    
}

