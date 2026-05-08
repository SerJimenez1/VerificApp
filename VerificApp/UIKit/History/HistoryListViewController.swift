import UIKit

final class HistoryListViewController: UITableViewController {
    private let store: VerificationStore
    private var records: [VerificationRecord] = []

    init(store: VerificationStore) {
        self.store = store
        super.init(style: .plain)
        title = "Historial"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = GradientBackgroundView()
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(VerificationTableViewCell.self, forCellReuseIdentifier: VerificationTableViewCell.reuseIdentifier)
        tableView.separatorColor = UIColor.white.withAlphaComponent(0.10)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 108
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        records = store.sortedRecords
        tableView.reloadData()
        updateBackground()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        records.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VerificationTableViewCell.reuseIdentifier, for: indexPath) as? VerificationTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: records[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = VerificationDetailViewController(record: records[indexPath.row])
        let nav = UINavigationController(rootViewController: detail)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(nav, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let record = records[indexPath.row]
        store.delete(records: [record])
        records.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        updateBackground()
    }

    private func updateBackground() {
        guard records.isEmpty else {
            tableView.backgroundView = nil
            return
        }

        let empty = UIStackView.vertical(spacing: 14)
        empty.alignment = .center
        empty.isLayoutMarginsRelativeArrangement = true
        empty.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 80, leading: 24, bottom: 24, trailing: 24)

        let image = UIImageView(image: UIImage(systemName: "clock.badge.questionmark"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = VerificDesign.lime
        image.contentMode = .scaleAspectFit

        let title = UILabel.make(text: "Sin historial todavía", font: .systemFont(ofSize: 22, weight: .black), lines: 1)
        let message = UILabel.make(
            text: "Tus verificaciones guardadas aparecerán aquí con su veredicto y desglose.",
            font: .systemFont(ofSize: 15, weight: .medium),
            color: UIColor.white.withAlphaComponent(0.72),
            lines: 0
        )
        message.textAlignment = .center

        empty.addArrangedSubview(image)
        empty.addArrangedSubview(title)
        empty.addArrangedSubview(message)

        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 48),
            image.heightAnchor.constraint(equalToConstant: 48)
        ])
        tableView.backgroundView = empty
    }
}
